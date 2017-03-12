require 'test_helper'
require 'importers/filter'

class FilterTest < ActiveSupport::TestCase
  test 'A filterset can be created' do
    filter = Importers::Filter.new

    assert_difference('Filterset.count', +1) do
      filterset = filter.create_filterset_from_file('.resources/filter_categories/angry.yml')
      assert filterset.valid?
      assert filterset.words.size == filter.filter_words.size
    end
  end
end
