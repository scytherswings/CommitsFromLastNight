require 'test_helper'
require 'importers/filter'
class FilterTest < ActiveSupport::TestCase
  test 'A filterset can be created' do
    filter = Importers::Filter.new
    filter.import_yaml('lib/resources/blacklist.yml')
    filter.import_csv('lib/resources/google_bad_words.csv')

    assert_difference('Filterset.count', +1) do
      filterset = filter.create_filterset('Test Filterset')
      assert filterset.valid?
      assert filterset.words.size == filter.blacklist_words.size
    end
  end
end
