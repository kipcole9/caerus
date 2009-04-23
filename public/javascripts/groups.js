Event.addBehavior({
	'.groupMember:click' : function(e) {
		e.stopPropagation();
		var element = e.element();							// What we clicked on		
		var groupMember = this;								
		var groupId = groupMember.id.split('_')[1];			// The Id of what we're updating or inserting into

		function cancelForm(e) {
			var groupForm = $('new_group');
			e.stopPropagation();
			e.stop();			
			if (groupForm) {
				var element = groupForm.previous(); // It's an edit
				if (element) {
					groupForm.slideUp({
						afterFinish: function(e) {
							groupForm.remove();
							element.slideDown();
						}
					});
				} else {
					groupForm.slideUp({
						afterFinish: function(e) {
							groupForm.remove();
						}
					});
				}
			}
		};

		var delegate = Event.delegate({
			'span' : function(e) {
				element = e.element().up('.group_member').down('ul.groups');
				if (element) element.toggle();
			},
			
			'img.editGroup' : function(e) {
				var inputMethod = '<input type="hidden" value="put" name="_method"/>'
				
				// Cancel any open form
				if ($('new_group')) cancelForm(e);

				// Insert form
				groupMember.down().insert({after: group});
				var groupForm = $('new_group');

				// Populate the form
				$('group_name').value = groupMember.select('h4 span').first().innerHTML.strip();
				$('group_description').value= groupMember.select('p').first().innerHTML.strip();
				groupForm.select('legend').first().update($('group_name').value);

				// Update the submit URL to point to this group
				var newAction = groupForm.action + '/' + groupId + '.js';
				groupForm.writeAttribute('action', newAction);

				// Add the _method input field
				groupForm.insert({bottom: inputMethod});

				// Show/hide relevant parts
				groupMember.down().fade();

				// Set focus
				fields = groupForm.select('input[focus], textarea[focus]');
				if (fields.length > 0) fields.first().focus();				
			},
			
			'img.addGroup' : function(e) {
				var insertPlace = groupMember;

				// Cancel any open form
				if ($('new_group')) cancelForm(e);

				// Insert form.  This whole li will be replaced
				// from the server request
				insertPlace.insert({
					after: "<li class='groupMember' id='newGroupMember'>" + group + "</li>"
				});
				Event.addBehavior.reload();

				// Set focus
				groupForm = $('new_group');
				fields = groupForm.select('input[focus], textarea[focus]');
				if (fields.length > 0) fields.first().focus();
			},
			
			'.submit_button input' : function(e) {
				var groupForm = $('new_group');
				var submitter = new Ajax.Request(groupForm.action, {
								asynchronous: true, 
								evalScripts: true,
								parameters: groupForm.serialize(element)
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
	
	'.groupMember:mouseover' : function(e) {
		e.stopPropagation();
		this.select('.buttons').first().show();
	},
	
	'.groupMember:mouseout' : function(e) {
		e.stopPropagation();
		this.select('.buttons').first().hide();
	},
		
	// Set each of them to be drop zones
	'.group' : function(e) {
		Droppables.add(this, {hoverclass: 'hover', accepts: ['user'], 
			onDrop: function(draggable, droppable, event) {
				// alert('Dropped ' + draggable.id + " onto " + droppable.id);
				if (draggable.hasClassName('user')) {
					userId = draggable.id.split('_')[1];
					groupId = droppable.id.split('_')[1];
					submitter = new Ajax.Request('/groups/' + groupId + '/members.js?id=' + userId, {
						method: 'post',
						asynchronous: true, 
						evalScripts: true
					});
				}
			}
		});
	}
});


