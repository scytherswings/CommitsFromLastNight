require 'test_helper'
require 'importers/filter'

class FilterTest < ActiveSupport::TestCase
  test 'A filterset can be created' do
    filter = Importers::Filter.new
    filter.import_yaml('lib/resources/filter_categories/profanity.yml')

    assert_difference('Filterset.count', +1) do
      filterset = filter.create_filterset('Test Filterset')
      assert filterset.valid?
      assert filterset.words.size == filter.filter_words.size
    end
  end
end
