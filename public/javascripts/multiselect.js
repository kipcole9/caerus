/*
  Proto!MultiSelect 0.2
  - Prototype version required: 6.0
  
  Credits:
  - Idea: Facebook + Apple Mail
  - Caret position method: Diego Perini <http://javascript.nwbox.com/cursor_position/cursor.js>
  - Guillermo Rauch: Original MooTools script
  - Ran Grushkowsky/InteRiders Inc. : Porting into Prototype and further development
  
  Changelog:
  - 0.1: translation of MooTools script
  - 0.2: renamed from Proto!TextboxList to Proto!MultiSelect, added new features/bug fixes
        added feature: support to fetch list on-the-fly using AJAX    Credit: Cheeseroll
        added feature: support for value/caption
        added feature: maximum results to display, when greater displays a scrollbar   Credit: Marcel
        added feature: filter by the beginning of word only or everywhere in the word   Credit: Kiliman
        added feature: shows hand cursor when going over options
        bug fix: the click event stopped working
        bug fix: the cursor does not 'travel' when going up/down the list   Credit: Marcel
*/

/* Copyright: InteRiders <http://interiders.com/> - Distributed under MIT - Keep this message! */

/*
== Loren Johnson, www.hellovenado.com -- 2/27/08 == 
bug fix: moved class variables into initialize so they happen per instance. This allows multiple controls per page
bug fix: added id_base attribute so that multiple controls on the same page have unique list item ids (won't work otherwise)
feature: Added newValues option and logic to allow new values to be created when ended with a comma (tag selector use case)           
mod: removed ajax fetch file happening on every search and moved it to initialization to laod all results immediately and not keep polling
mod: added "fetchMethod" option so I could better accomodate my RESTful ways and set a "get" for retrieving
mod: added this.update to the add and dispose methods to keep the target input box values always up to date
mod: moved ResizableTextBox, TextBoxList and FaceBookList all into same file
mod: added extra line breaks and fixed-up some indentation for readability
mod: spaceReplace option added to allow handling of new tag values when the tagging scheme doesn't allow spaces, 
     this is set as blank by default and will have no impact

== Zuriel Barron, severelimitation.com -- 3/1/08 ==
bug fix: fixed bug where it was not loading initial list values
bug fix: new values are not added into the autocomplete list upon removal
bug fix: improved browser compatibility (Safari, IE)
*/

/*
I needed to use this for 100's of records (currently 768, but this will grow), and found that it was extremely slow to respond, so I extended it a little.

It can be found at: http://pastebin.com/f64a530f8

I have modified this code to provide the following extras (the defaults are there only to keep backwards compatibility, so if upgrading to this version you should not see any changes to behaviour (that's not misspelt, I'm an Aussie :P)):

- Option to specify whether to perform a case sensitive search or not (option: "caseSensitive", default: false).
- Option to specify whether you want the search to be performed by regular expression or by simple text search (option: "regexSearch", default: true). Non-regular expression searching is MUCH faster than by regular expression (this is the way the real Facebook autocomplete search works).
- Option to specify a callback upon the user hitting Enter/Return when the input is blank (option: "onEmptyInput", default: function(){}). I needed this because I did not want the user to have to move their hand off the keyboard to the mouse and then click on the submit/action button.
- Option to specify the maximum number of results to show (NOT the same as the "result" option, see comments below) (option: "maxResults", default: 10).


NOTE ON THE NON-REGULAR EXPRESSION SEARCH: If using non-regular expression search mode, the option "matchWord" WILL HAVE NO EFFECT on the results (ie., it will behave as if matchWord were set to false). This can be fixed but at 5am my pillow is looking too good to spend more time on this, so if anyone needs this feel free to email me a request and I'll get it done (nick at footysx.com.au).

NOTE ON THE MAXRESULTS OPTION: The difference between the options "results" and "maxResults" is that "results" specifies the maximum number of visible rows allowed to be shown to the user before a scrollbar activates, whereas "maxResults" specifies the maximum number of results allowed to be in the scrollable list.


The pastebin link also contains a diff to the original code (although the output of diff looks terrible).
*/

// Added key contstant for COMMA watching happiness
Object.extend(Event, { KEY_COMMA: 188 });

var ResizableTextbox = Class.create({  
  
  initialize: function(element, options) {
    var that = this;
    this.options = $H({
      min: 5,
      max: 500,
      step: 7
    });
    this.options.update(options);
    this.el = $(element);
    this.width = this.el.offsetWidth;
    this.el.observe(
      'keyup', function() {
        var newsize = that.options.get('step') * $F(this).length;
        if(newsize <= that.options.get('min')) newsize = that.width;
        if(! ($F(this).length == this.retrieveData('rt-value') || newsize <= that.options.min || newsize >= that.options.max))
          this.setStyle({'width': newsize});
      }).observe('keydown', function() {
        this.cacheData('rt-value', $F(this).length);
      });
  }
});

var TextboxList = Class.create({
	
  initialize: function(element, options) {
    this.options = $H({/*
      onFocus: $empty,
      onBlur: $empty,
      onInputFocus: $empty,
      onInputBlur: $empty,
      onBoxFocus: $empty,
      onBoxBlur: $empty,
      onBoxDispose: $empty,*/
      resizable: {},
      className: 'bit',
      separator: ',',
      extrainputs: true,
      startinput: true,
      hideempty: true,
      newValues: false,
      spaceReplace: '',
      fetchFile: undefined,
      fetchMethod: 'get',
      results: 10,
      maxResults: 0, // 0 = set to default (which is 10 (see FacebookList class))
      wordMatch: false,
      onEmptyInput: function(input){},
      caseSensitive: false,
      regexSearch: true
    });
    this.options.update(options);
    this.element = $(element).hide();    
    this.bits = new Hash();
    this.events = new Hash();
    this.count = 0;
    this.current = false;
    this.maininput = this.createInput({'class': 'maininput'});
    this.holder = new Element('ul', {
      'class': 'holder'
    }).insert(this.maininput);
    this.element.insert({'before':this.holder});
    this.holder.observe('click', function(event){
      event.stop();
      if(this.maininput != this.current) this.focus(this.maininput);     
    }.bind(this));
    this.makeResizable(this.maininput);
    this.setEvents();
  },
  
  setEvents: function() {
    document.observe(Prototype.Browser.IE ? 'keydown' : 'keypress', function(e) {      
      if(! this.current) return;
      if(this.current.retrieveData('type') == 'box' && e.keyCode == Event.KEY_BACKSPACE) e.stop();
    }.bind(this));      
         
    document.observe(
      'keyup', function(e) {
        e.stop();
        if(! this.current) return;
        switch(e.keyCode){
          case Event.KEY_LEFT: return this.move('left');
          case Event.KEY_RIGHT: return this.move('right');
          case Event.KEY_DELETE:
          case Event.KEY_BACKSPACE: return this.moveDispose();
        }
      }.bind(this)).observe(  
      'click', function() { document.fire('blur'); }.bindAsEventListener(this)
    );
  },
  
  update: function() {
    this.element.value = this.bits.values().join(this.options.get('separator'));
    return this;
  },
  
  add: function(text, html) {
    var id = this.id_base + '-' + this.count++;
    var el = this.createBox($pick(html, text), {'id': id, 'class': this.options.get('className'), 'newValue' : text.newValue ? 'true' : 'false'});
    (this.current || this.maininput).insert({'before':el});                                         
    el.observe('click', function(e) {
      e.stop();
      this.focus(el);
    }.bind(this));
    this.bits.set(id, text.value);
    // Dynamic updating... why not?
    this.update();
    if(this.options.get('extrainputs') && (this.options.get('startinput') || el.previous())) this.addSmallInput(el,'before');
    return el;
  },
  
  addSmallInput: function(el, where) {
    var input = this.createInput({'class': 'smallinput'});
    el.insert({}[where] = input);
    input.cacheData('small', true);
    this.makeResizable(input);
    if(this.options.get('hideempty')) input.hide();
    return input;
  },
  
  dispose: function(el) {
    this.bits.unset(el.id);
    // Dynamic updating... why not?
    this.update();
    if(el.previous() && el.previous().retrieveData('small')) el.previous().remove();
    if(this.current == el) this.focus(el.next());
    if(el.retrieveData('type') == 'box') el.onBoxDispose(this);
    el.remove();    
    return this;
  },
  
  focus: function(el, nofocus) {
    if(! this.current) el.fire('focus');
    else if(this.current == el) return this;
    this.blur();
    el.addClassName(this.options.get('className') + '-' + el.retrieveData('type') + '-focus');
    if(el.retrieveData('small')) el.setStyle({'display': 'block'});
    if(el.retrieveData('type') == 'input') {
      el.onInputFocus(this);      
      if(! nofocus) this.callEvent(el.retrieveData('input'), 'focus');
    }
    else el.fire('onBoxFocus');
    this.current = el;    
    return this;
  },
  
  blur: function(noblur) {
    if(! this.current) return this;
    if(this.current.retrieveData('type') == 'input') {
      var input = this.current.retrieveData('input');
      if(! noblur) this.callEvent(input, 'blur');   
      input.onInputBlur(this);
    }
    else this.current.fire('onBoxBlur');
    if(this.current.retrieveData('small') && ! input.get('value') && this.options.get('hideempty')) 
      this.current.hide();
    this.current.removeClassName(this.options.get('className') + '-' + this.current.retrieveData('type') + '-focus');
    this.current = false;
    return this;
  },
  
  createBox: function(text, options) {
    return new Element('li', options).addClassName(this.options.get('className') + '-box').update(text.caption).cacheData('type', 'box');
  },
  
  createInput: function(options) {
    var li = new Element('li', {'class': this.options.get('className') + '-input'});
    var el = new Element('input', Object.extend(options,{'type': 'text'}));
    el.observe('click', function(e) { e.stop(); }).observe('focus', function(e) { if(! this.isSelfEvent('focus')) this.focus(li, true); }.bind(this)).observe('blur', function() { if(! this.isSelfEvent('blur')) this.blur(true); }.bind(this)).observe('keydown', function(e) { this.cacheData('lastvalue', this.value).cacheData('lastcaret', this.getCaretPosition()); });
    var tmp = li.cacheData('type', 'input').cacheData('input', el).insert(el);
    return tmp;
  },
  
  callEvent: function(el, type) {
    this.events.set(type, el);
    el[type]();
  },
  
  isSelfEvent: function(type) {
    return (this.events.get(type)) ? !! this.events.unset(type) : false;
  },
  
  makeResizable: function(li) {
    var el = li.retrieveData('input');
    el.cacheData('resizable', new ResizableTextbox(el, Object.extend(this.options.get('resizable'),{min: el.offsetWidth, max: (this.element.getWidth()?this.element.getWidth():0)})));
    return this;
  },
  
  checkInput: function() {
    var input = this.current.retrieveData('input');
    return (! input.retrieveData('lastvalue') || (input.getCaretPosition() === 0 && input.retrieveData('lastcaret') === 0));
  },
  
  move: function(direction) {
    var el = this.current[(direction == 'left' ? 'previous' : 'next')]();
    if(el && (! this.current.retrieveData('input') || ((this.checkInput() || direction == 'right')))) this.focus(el);
    return this;
  },
  
  moveDispose: function() {
    if(this.current.retrieveData('type') == 'box') return this.dispose(this.current);
    if(this.checkInput() && this.bits.keys().length && this.current.previous()) return this.focus(this.current.previous());
  }
  
});

//helper functions 
Element.addMethods({
  getCaretPosition: function() {
    if (this.createTextRange) {
      var r = document.selection.createRange().duplicate();
        r.moveEnd('character', this.value.length);
        if (r.text === '') return this.value.length;
        return this.value.lastIndexOf(r.text);
    } else return this.selectionStart;
  },
  cacheData: function(element, key, value) { 
    if (Object.isUndefined(this[$(element).identify()]) || !Object.isHash(this[$(element).identify()]))
        this[$(element).identify()] = $H();
    this[$(element).identify()].set(key,value);
    return element;
  },
  retrieveData: function(element,key) {
    return this[$(element).identify()].get(key);
  }  
});

function $pick(){for(var B=0,A=arguments.length;B<A;B++){if(!Object.isUndefined(arguments[B])){return arguments[B];}}return null;}

/*
  Proto!MultiSelect 0.2
  - Prototype version required: 6.0
  
  Credits:
  - Idea: Facebook
  - Guillermo Rauch: Original MooTools script
  - Ran Grushkowsky/InteRiders Inc. : Porting into Prototype and further development
  
  Changelog:
  - 0.1: translation of MooTools script
  - 0.2: renamed from Proto!TextboxList to Proto!MultiSelect, added new features/bug fixes
        added feature: support to fetch list on-the-fly using AJAX    Credit: Cheeseroll
        added feature: support for value/caption
        added feature: maximum results to display, when greater displays a scrollbar   Credit: Marcel
        added feature: filter by the beginning of word only or everywhere in the word   Credit: Kiliman
        added feature: shows hand cursor when going over options
        bug fix: the click event stopped working
        bug fix: the cursor does not 'travel' when going up/down the list   Credit: Marcel
*/

/* Copyright: InteRiders <http://interiders.com/> - Distributed under MIT - Keep this message! */

var FacebookList = Class.create(TextboxList, { 
  
  initialize: function($super,element, autoholder, options, func) {
    $super(element, options);
    this.loptions = $H({    
      autocomplete: {
        'opacity': 1,
        'maxresults': 10,
        'minchars': 1
      }
    });

    this.id_base = $(element).identify() + "_" + this.options.get("className");

    this.data = [];    
    this.autoholder = $(autoholder).setOpacity(this.loptions.get('autocomplete').opacity);
    this.autoholder.observe('mouseover',function() {this.curOn = true;}.bind(this)).observe('mouseout',function() {this.curOn = false;}.bind(this));
    this.autoresults = this.autoholder.select('ul').first();
	var children = this.autoresults.select('li');
    children.each(function(el) { this.add({value:el.readAttribute('value'),caption:el.innerHTML}); }, this);

    // Loading the options list only once at initialize. 
    // This would need to be further extended if the list was exceptionally long
    if (!Object.isUndefined(this.options.get('fetchFile'))) {
      new Ajax.Request(this.options.get('fetchFile'), {
        method: this.options.get('fetchMethod'),
        onSuccess: function(transport) {
          transport.responseText.evalJSON(true).each(function(t) { 
            this.autoFeed(t) }.bind(this));
            this.createSearchableData();
          }.bind(this)
        }
      );
    }

  },

  // This function creates an array of lowercase'd captions so we
  // can search through them with .indexOf() instead of with a regular expression.
  createSearchableData: function() {
    if (this.data.length) {
      this._data_searchable = new Array();
      var with_case = this.options.get('caseSensitive');
      for (var i=0,len=this.data.length; i<len; i++) {
        this._data_searchable[i] = (with_case ? this.data[i].evalJSON(true).caption : this.data[i].evalJSON(true).caption.toLowerCase());
      }
    }
  },
  
  autoShow: function(search) {
    this.autoholder.setStyle({'display': 'block'});
    this.autoholder.descendants().each(function(e) { e.hide() });
    if(! search || ! search.strip() || (! search.length || search.length < this.loptions.get('autocomplete').minchars)) 
    {
      this.autoholder.select('.default').first().setStyle({'display': 'block'});
      this.resultsshown = false;
    } else {
      this.resultsshown = true;
      this.autoresults.setStyle({'display': 'block'}).update('');
      if (!this.options.get('regexSearch')) {
        var matches = new Array();
        if (search) {
          if (!this.options.get('caseSensitive')) {
            search = search.toLowerCase();
          }
          var matches_found = 0;
          for (var i=0,len=this._data_searchable.length; i<len; i++) {
            if (this._data_searchable[i].indexOf(search) >= 0) {
              matches[matches_found++] = this.data[i];
            }
          }
        }
      } else {
        if (this.options.get('wordMatch'))
          var regexp = new RegExp("(^|\\s)"+search,(!this.options.get('caseSensitive') ? 'i' : ''));
        else
          var regexp = new RegExp(search,(!this.options.get('caseSensitive') ? 'i' : ''));
        var matches = this.data.filter( 
        function(str) { 
          return str ? regexp.test(str.evalJSON(true).caption) : false;
        });
      }
      var count = 0;
      matches.each(
            function(result, ti) {
              count++;
              if(ti >= (this.options.get('maxResults') ? this.options.get('maxResults') : this.loptions.get('autocomplete').maxresults)) return;
              var that = this;
              var el = new Element('li');
              el.observe('click',function(e) { 
                e.stop();
                that.autoAdd(this); 
            }
          ).observe('mouseover', function() { that.autoFocus(this); } ).update(
            this.autoHighlight(result.evalJSON(true).caption, search)
          );
          this.autoresults.insert(el);
          el.cacheData('result', result.evalJSON(true));
          if(ti == 0) this.autoFocus(el);
        }, 
        this
      );
    }
    if (count > this.options.get('results'))
      this.autoresults.setStyle({'height': (this.options.get('results')*24)+'px'});
    else
      this.autoresults.setStyle({'height': (count?(count*24):0)+'px'});
    return this;
  },
  
  autoHighlight: function(html, highlight) {
    return html.gsub(new RegExp(highlight,'i'), function(match) {
      return '<em>' + match[0] + '</em>';
    });
  },
  
  autoHide: function() {    
    this.resultsshown = false;
    this.autoholder.hide();
    return this;
  },
  
  autoFocus: function(el) {
    if(! el) return;
    if(this.autocurrent) this.autocurrent.removeClassName('auto-focus');
    this.autocurrent = el.addClassName('auto-focus');
    return this;
  },
  
  autoMove: function(direction) {    
    if(!this.resultsshown) return;
    this.autoFocus(this.autocurrent[(direction == 'up' ? 'previous' : 'next')]());
    this.autoresults.scrollTop = this.autocurrent.positionedOffset()[1]-this.autocurrent.getHeight();         
    return this;
  },
  
  autoFeed: function(text) {
    if (this.data.indexOf(Object.toJSON(text)) == -1)
      this.data.push(Object.toJSON(text));
    return this;
  },
  
  autoAdd: function(el) {
    if(this.newvalue && this.options.get("newValues")) {
      this.add({caption: el.value, value: el.value, newValue: true});
      var input = el;
    } else if(!el || ! el.retrieveData('result')) {
      return;
    } else {
      this.add(el.retrieveData('result'));
      delete this.data[this.data.indexOf(Object.toJSON(el.retrieveData('result')))];
      var input = this.lastinput || this.current.retrieveData('input');
    }
    this.autoHide();
    input.clear().focus();
    return this;
  },
  
  createInput: function($super,options) {
    var li = $super(options);
    var input = li.retrieveData('input');
    input.observe('keydown', function(e) {
        this.dosearch = false;
        this.newvalue = false;
        
        switch(e.keyCode) {
          case Event.KEY_UP: e.stop(); return this.autoMove('up');
          case Event.KEY_DOWN: e.stop(); return this.autoMove('down');        
          case Event.KEY_COMMA:
            if(this.options.get('newValues')) {
              new_value_el = this.current.retrieveData('input');
              new_value_el.value = new_value_el.value.strip().gsub(",","");
              if(!this.options.get("spaceReplace").blank()) new_value_el.gsub(" ", this.options.get("spaceReplace"));
              if(!new_value_el.value.blank()) {
                e.stop();
                this.newvalue = true;
                this.autoAdd(new_value_el);
              }
            }
            break;
          case Event.KEY_RETURN:
            // If the text input is blank and the user hits Enter call the
            // onEmptyInput callback.
            if (String('').valueOf() == String(this.current.retrieveData('input').getValue()).valueOf()) {
              this.options.get("onEmptyInput")();
            }
            e.stop();
            if(! this.autocurrent) break;
            this.autoAdd(this.autocurrent);
            this.autocurrent = false;
            this.autoenter = true;
            break;
          case Event.KEY_ESC: 
            this.autoHide();
            if(this.current && this.current.retrieveData('input'))
              this.current.retrieveData('input').clear();
            break;
          default: this.dosearch = true;
        }
    }.bind(this));
    input.observe('keyup',function(e) {
	
        switch(e.keyCode) {
          case Event.KEY_UP: 
          case Event.KEY_DOWN: 
          case Event.KEY_RETURN:
          case Event.KEY_ESC: 
            break;              
          default: 
            // Removed Ajax.Request from here and moved to initialize, 
            // now doesn't create server queries every search but only 
            // refreshes the list on initialize (page load) 
            if(this.dosearch) this.autoShow(input.value);
        }        
    }.bind(this));
    input.observe(Prototype.Browser.IE ? 'keydown' : 'keypress', function(e) { 
      if(this.autoenter) e.stop();
      this.autoenter = false;
    }.bind(this));
    return li;
  },
  
  createBox: function($super,text, options) {
    var li = $super(text, options);
    li.observe('mouseover',function() { 
        this.addClassName('bit-hover');
    }).observe('mouseout',function() { 
        this.removeClassName('bit-hover') 
    });
    var a = new Element('a', {
      'href': '#',
      'class': 'closebutton'
      }
    );
    a.observe('click',function(e) {
      e.stop();
      if(! this.current) this.focus(this.maininput);
      this.dispose(li);
    }.bind(this));
    li.insert(a).cacheData('text', Object.toJSON(text));
    return li;
  }
  
});

Element.addMethods({
  onBoxDispose: function(item,obj) { 
    // Set to not to "add back" values in the drop-down upon delete if they were new values
	item = item.retrieveData('text').evalJSON(true);
	if(!item.newValue)
    	obj.autoFeed(item); 
  },
  onInputFocus: function(el,obj) { obj.autoShow(); },    
  onInputBlur: function(el,obj) { 
      obj.lastinput = el;
      if(!obj.curOn) {
          obj.blurhide = obj.autoHide.bind(obj).delay(0.1);
      }
  },
  filter: function(D,E) { var C=[];for(var B=0,A=this.length;B<A;B++){if(D.call(E,this[B],B,this)){C.push(this[B]);}} return C; }
});
