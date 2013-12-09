App.Note = Ember.Resource.extend({
  resourceUrl:        '/notes',
  resourceName:       'note',
  resourceProperties: ['title', 'content', 'tag_num'],

  num_tags: Ember.computed(function() {
    return this.get('tag_num');
  }).property('tag_num')
});
