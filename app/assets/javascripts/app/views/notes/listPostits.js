App.ListPostitsView = Ember.View.extend({
  templateName:    'app/templates/notes/listPostits',
  notesBinding: 'App.notesController',


  refreshListing: function() {
    App.notesController.findAll();
  }
});

