require File.dirname(__FILE__) + '/../init'

describe 'client API library', :shared => true do
  it 'should have all filters working' do
    @sphinx.SetServer('localhost', 3312)
    @sphinx.SetLimits(1, 100, 20, 30)
    @sphinx.SetMaxQueryTime(5)
    @sphinx.SetMatchMode(Sphinx::Client::SPH_MATCH_EXTENDED2)
    @sphinx.SetRankingMode(Sphinx::Client::SPH_RANK_BM25)
    @sphinx.SetSortMode(Sphinx::Client::SPH_SORT_RELEVANCE)
    @sphinx.SetFieldWeights('group_id' => 10, 'rating' => 20)
    @sphinx.SetIndexWeights('test1' => 20, 'test2' => 30)
    @sphinx.SetIDRange(1, 100)
    @sphinx.SetFilter('group_id', [1], true)
    @sphinx.SetFilterRange('group_id', 1, 2, true)
    @sphinx.SetFilterFloatRange('rating', 1, 3, true)
    @sphinx.SetGroupBy('created_at', Sphinx::Client::SPH_GROUPBY_DAY)
    @sphinx.SetGroupDistinct('group_id')
    @sphinx.SetRetries(5, 10)
    result = @sphinx.Query('wifi', 'test1')

    result.should_not be_nil
  end
  
  it 'should parse response in Query method' do
    result = @sphinx.Query('wifi', 'test1')
    validate_results_wifi(result)
  end

  it 'should process 64-bit keys in Query method' do
    result = @sphinx.Query('wifi', 'test2')
    result['total_found'].should == 3
    result['matches'].length.should == 3
    result['matches'][0]['id'].should == 4294967298
    result['matches'][1]['id'].should == 4294967299
    result['matches'][2]['id'].should == 4294967297
  end
  
  it 'should parse batch-query responce in RunQueries method' do
    @sphinx.AddQuery('wifi', 'test1')
    @sphinx.AddQuery('gprs', 'test1')
    results = @sphinx.RunQueries
    results.should be_an(Array)
    results.length.should == 2
    validate_results_wifi(results[0])
  end
  
  it 'should parse response in BuildExcerpts method' do
    result = @sphinx.BuildExcerpts(['what the world', 'London is the capital of Great Britain'], 'test1', 'the')
    result.should == ['what <b>the</b> world', 'London is <b>the</b> capital of Great Britain']
  end

  it 'should parse response in BuildKeywords method' do
    result = @sphinx.BuildKeywords('wifi gprs', 'test1', true)
    result.should == [
      { 'normalized' => 'wifi', 'tokenized' => 'wifi', 'hits' => 6, 'docs' => 3 },
      { 'normalized' => 'gprs', 'tokenized' => 'gprs', 'hits' => 1, 'docs' => 1 }
    ]
  end

  it 'should parse response in UpdateAttributes method' do
    @sphinx.UpdateAttributes('test1', ['group_id'], { 2 => [1] }).should == 1
    result = @sphinx.Query('wifi', 'test1')
    result['matches'][0]['attrs']['group_id'].should == 1
    @sphinx.UpdateAttributes('test1', ['group_id'], { 2 => [2] }).should == 1
    result = @sphinx.Query('wifi', 'test1')
    result['matches'][0]['attrs']['group_id'].should == 2
  end
  
  it 'should process errors in Query method' do
  	@sphinx.Query('wifi', 'fakeindex').should be_false
  	@sphinx.GetLastError.length.should_not == 0
  end

  it 'should process errors in RunQueries method' do
  	@sphinx.AddQuery('wifi', 'fakeindex')
  	r = @sphinx.RunQueries
  	r.should be_an(Array)
  	r[0]['error'].length.should_not == 0
  end
  
  def validate_results_wifi(result)
    result['total_found'].should == 3
    result['matches'].length.should == 3
    result['time'].should_not be_nil
    result['attrs'].should == {
      'group_id' => Sphinx::Client::SPH_ATTR_INTEGER,
      'created_at' => Sphinx::Client::SPH_ATTR_TIMESTAMP,
      'rating' => Sphinx::Client::SPH_ATTR_FLOAT,
      'tags' => Sphinx::Client::SPH_ATTR_MULTI | Sphinx::Client::SPH_ATTR_INTEGER
    }
    result['fields'].should == [ 'name', 'description' ]
    result['total'].should == 3
    result['matches'].should be_an(Array)
    
    result['matches'][0]['id'].should == 2
    result['matches'][0]['weight'].should == 2
    result['matches'][0]['attrs']['group_id'].should == 2
    result['matches'][0]['attrs']['created_at'].should == 1175658555
    result['matches'][0]['attrs']['tags'].should == [5, 6, 7, 8]
    ('%0.2f' % result['matches'][0]['attrs']['rating']).should == '54.85'
    
    result['matches'][1]['id'].should == 3
    result['matches'][1]['weight'].should == 2
    result['matches'][1]['attrs']['group_id'].should == 1
    result['matches'][1]['attrs']['created_at'].should == 1175658647
    result['matches'][1]['attrs']['tags'].should == [1, 7, 9, 10]
    ('%0.2f' % result['matches'][1]['attrs']['rating']).should == '16.25'

    result['matches'][2]['id'].should == 1
    result['matches'][2]['weight'].should == 1
    result['matches'][2]['attrs']['group_id'].should == 1
    result['matches'][2]['attrs']['created_at'].should == 1175658490
    result['matches'][2]['attrs']['tags'].should == [1, 2, 3, 4]
    ('%0.2f' % result['matches'][2]['attrs']['rating']).should == '13.32'
    
    result['words'].should == { 'wifi' => { 'hits' => 6, 'docs' => 3 } }
  end
end

# To execute these tests you need to execute sphinx_test.sql and configure sphinx using sphinx.conf
# (both files are placed under sphinx directory)
describe 'The Sphinx::Client connected to Sphinx' do
  before(:each) { @sphinx = Sphinx::Client.new }
  after (:each) { @sphinx.destroy }
  
  it_should_behave_like 'client API library'
end

describe 'The Sphinx::FastClient connected to Sphinx' do
  before(:each) { @sphinx = Sphinx::FastClient.new }
  after (:each) { @sphinx.destroy }
  
  it_should_behave_like 'client API library'
end
