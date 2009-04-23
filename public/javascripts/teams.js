Event.addBehavior({
	'.team_member:click' : function(e) {
		e.stopPropagation();
		var element = e.element();							// What we clicked on		
		var teamMember = this;								
		var teamId = teamMember.id.split('_')[1];			// The Id of what we're updating or inserting into

		function cancelForm(e) {
			var teamForm = $('new_team');
			e.stopPropagation();
			e.stop();			
			if (teamForm) {
				var element = teamForm.previous(); // It's an edit
				if (element) {
					teamForm.slideUp({
						afterFinish: function(e) {
							teamForm.remove();
							element.slideDown();
						}
					});
				} else {
					teamForm.slideUp({
						afterFinish: function(e) {
							teamForm.remove();
						}
					});
				}
			}
		};

		var delegate = Event.delegate({
			'span' : function(e) {
				element = e.element().up('.team_member').down('ul.teams');
				if (element) element.toggle();
			},
			
			'img.editTeam' : function(e) {
				var inputMethod = '<input type="hidden" value="put" name="_method"/>'
				
				// Cancel any open form
				if ($('new_team')) cancelForm(e);

				// Insert form
				teamMember.down().insert({after: team});
				var teamForm = $('new_team');

				// Populate the form
				$('team_name').value = teamMember.select('h4 span').first().innerHTML.strip();
				$('team_description').value= teamMember.select('p').first().innerHTML.strip();
				teamForm.select('legend').first().update($('team_name').value);

				// Update the submit URL to point to this team
				var newAction = teamForm.action + '/' + teamId + '.js';
				teamForm.writeAttribute('action', newAction);

				// Add the _method input field
				teamForm.insert({bottom: inputMethod});

				// Show/hide relevant parts
				teamMember.down().fade();

				// Set focus
				fields = teamForm.select('input[focus], textarea[focus]');
				if (fields.length > 0) fields.first().focus();				
			},
			
			'img.addTeam' : function(e) {
				var ul = "<ul class='teams'></ul>";
				var insertPlace = teamMember.down('ul.teams');
				if (!insertPlace) {
					teamMember.insert({bottom: ul});
					insertPlace = teamMember.down('ul.teams');
				}

				// Cancel any open form
				if ($('new_team')) cancelForm(e);

				// Insert form.  This whole li will be replaced
				// from the server request
				insertPlace.insert({
					top: "<li class='team_member'>" + team + '</li>'
				});

				// Populate the form
				$('team_parent_id').value = teamId;

				// Set focus
				teamForm = $('new_team');
				fields = teamForm.select('input[focus], textarea[focus]');
				if (fields.length > 0) fields.first().focus();
			},
			
			'.submit_button input' : function(e) {
				var teamForm = $('new_team');
				var submitter = new Ajax.Request(teamForm.action, {
								asynchronous: true, 
								evalScripts: true,
								parameters: teamForm.serialize(element)
							});
				e.stop();
				return false;
			},
			
			'.submit_button a' : function(e) {
				cancelForm(e);
				return false;
			}
		});
		delegate(e);	
	},
	
	'.team_member:mouseover' : function(e) {
		e.stopPropagation();
		this.down().select('.buttons').first().show();
	},
	
	'.team_member:mouseout' : function(e) {
		e.stopPropagation();
		this.down().select('.buttons').first().hide();
	},
	
	'.root:mouseover' : function(e) {
		e.stopPropagation();
		this.down().select('.buttons').first().show();
	},
	
	'.root:mouseout' : function(e) {
		e.stopPropagation();
		this.down().select('.buttons').first().hide();
	},
		
	// Set each of them to be drop zones
	'.team' : function(e) {
		new Draggable(this, {ghosting: true, revert: true});
		Droppables.add(this, {hoverclass: 'hover', accepts: ['team', 'user'], 
			onDrop: function(draggable, droppable, event) {
				if (draggable.hasClassName('user')) {
					var userId = draggable.id.split('_')[1];
					var teamId = droppable.id.split('_')[1];
					var submitter = new Ajax.Request('/teams/' + teamId + '/members.js?id=' + userId, {
						method: 'post',
						asynchronous: true, 
						evalScripts: true
					});
				} else if (draggable.hasClassName('team')) {
					var fromId = draggable.id.split('_')[1];
					var toId = droppable.id.split('_')[1];
					var submitter = new Ajax.Request('/teams/' + toId + '/merge/' + fromId, {
						method: 'put',
						asynchronous: true, 
						evalScripts: true
					});
				}
			}
		});
	}
});

