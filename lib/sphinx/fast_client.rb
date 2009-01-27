# = fast_client.rb - Wrapper for pure C Sphinx client API
# 
# Author::    Dmytro Shteflyuk <mailto:kpumuk@kpumuk.info>.
# Copyright:: Copyright (c) 2009 Dmytro Shteflyuk
# License::   Distributes under the GPLv2 license.
# Version::   0.2.0
# Website::   http://kpumuk.info/projects/ror-plugins/sphinx
#
# This library is distributed under the terms of the GPLv2 license.

# == Sphinx Client API
# 
# The Sphinx Client API is used to communicate with <tt>searchd</tt>
# daemon and get search results from Sphinx.
# 
# === Usage
# 
#   begin
#     sphinx = Sphinx::FastClient.new
#     result = sphinx.Query('test')
#     ids = result['matches'].map { |match| match['id'] }.join(',')
#     posts = Post.find :all, :conditions => "id IN (#{ids})"
#   
#     docs = posts.map(&:body)
#     excerpts = sphinx.BuildExcerpts(docs, 'index', 'test')
#   ensure
#     sphinx.destroy
#   end

module Sphinx

  # A wrapper for pure C Sphinx client API.
  class FastClient
    Lib = Rlibsphinxclient

    # Constructs the <tt>Sphinx::FastClient</tt> object and sets options to their default values.
    def initialize
      @sphinx = Lib.sphinx_create(true)
    end

    # Destroys all internal memory buffers. Should be called when Sphinx API is no needed.
    def destroy
      Lib.sphinx_destroy(@sphinx)
      @sphinx = nil
    end
    
    # See Client.GetLastError for details.
    def GetLastError
      Lib.sphinx_error(@sphinx)
    end

    # See Client.GetLastWarning for details.
    def GetLastWarning
      Lib.sphinx_warning(@sphinx)
    end
    
    # See Client.SetServer for details.
    def SetServer(host, port)
      Lib.sphinx_set_server(@sphinx, host, port)
    end

    def SetConnectionTimeout(seconds)
      Lib.sphinx_set_connect_timeout(@sphinx, seconds)
    end

    # See Client.SetLimits for details.
    def SetLimits(offset, limit, max_matches = 0, cutoff = 0)
      Lib.sphinx_set_limits(@sphinx, offset, limit, max_matches, cutoff)
    end

    # See Client.SetMaxQueryTime for details.
    def SetMaxQueryTime(max_query_time)
      Lib.sphinx_set_max_query_time(@sphinx, max_query_time)
    end

    # See Client.SetMatchMode for details.
    def SetMatchMode(mode)
      mode = Lib.const_get("SPH_MATCH_#{mode.to_s.upcase}") if mode.is_a? Symbol
      Lib.sphinx_set_match_mode(@sphinx, mode)
    end
    
    # See Client.SetRankingMode for details.
    def SetRankingMode(ranker)
      ranker = Lib.const_get("SPH_RANK_#{ranker.to_s.upcase}") if ranker.is_a? Symbol
      Lib.sphinx_set_ranking_mode(@sphinx, ranker)
    end
    
    # See Client.SetSortMode for details.
    def SetSortMode(mode, sortby = '')
      mode = Lib.const_get("SPH_SORT_#{mode.to_s.upcase}") if mode.is_a? Symbol
      Lib.sphinx_set_sort_mode(@sphinx, mode, sortby)
    end
    
    # See Client.SetFieldWeights for details.
    def SetFieldWeights(weights)
      Lib.sphinx_set_field_weights(@sphinx, weights.size, weights.keys, weights.values)
    end
    
    # See Client.SetIndexWeights for details.
    def SetIndexWeights(weights)
      Lib.sphinx_set_index_weights(@sphinx, weights.size, weights.keys, weights.values)
    end
    
    # See Client.SetIDRange for details.
    def SetIDRange(min, max)
      Lib.sphinx_set_id_range(@sphinx, min, max)
    end
    
    # See Client.SetFilter for details.
    def SetFilter(attribute, values, exclude = false)
      Lib.sphinx_add_filter(@sphinx, attribute, values.length, values, exclude)
    end

    # See Client.SetFilterRange for details.
    def SetFilterRange(attribute, min, max, exclude = false)
      Lib.sphinx_add_filter_range(@sphinx, attribute, min, max, exclude)
    end
    
    # See Client.SetFilterFloatRange for details.
    def SetFilterFloatRange(attribute, min, max, exclude = false)
      Lib.sphinx_add_filter_float_range(@sphinx, attribute, min, max, exclude)
    end
    
    # See Client.SetGeoAnchor for details.
    def SetGeoAnchor(attrlat, attrlong, lat, long)
      Lib.sphinx_set_geoanchor(@sphinx, attrlat, attrlong, lat, long)
    end
    
    # See Client.SetGroupBy for details.
    def SetGroupBy(attribute, func, groupsort = '@group desc')
      Lib.sphinx_set_groupby(@sphinx, attribute, func, groupsort)
    end
    
    # See Client.SetGroupDistinct for details.
    def SetGroupDistinct(attribute)
      Lib.sphinx_set_groupby_distinct(@sphinx, attribute)
    end
    
    # See Client.SetRetries for details.
    def SetRetries(count, delay = 0)
      Lib.sphinx_set_retries(@sphinx, count, delay)
    end
    
    # See Client.ResetFilters for details.
    def ResetFilters
      Lib.sphinx_reset_filters(@sphinx)
    end
    
    # See Client.ResetGroupBy for details.
    def ResetGroupBy
      Lib.sphinx_reset_groupby(@sphinx)
    end
    
    # See Client.Query for details.
    def Query(query, index = '*', comment = '')
      Lib.sphinx_query(@sphinx, query, index, comment)
    end
    
    # See Client.AddQuery for details.
    def AddQuery(query, index = '*', comment = '')
      Lib.sphinx_add_query(@sphinx, query, index, comment)
    end
    
    # See Client.RunQueries for details.
    def RunQueries
      Lib.sphinx_run_queries(@sphinx)
    end
    
    # See Client.BuildExcerpts for details.
    def BuildExcerpts(docs, index, words, opts = {})
      Lib.sphinx_build_excerpts(@sphinx, docs.size, docs, index, words, opts)
    end
    
    # See Client.BuildKeywords for details.
    def BuildKeywords(query, index, hits)
      Lib.sphinx_build_keywords(@sphinx, query, index, hits)
    end
    
    # See Client.UpdateAttributes for details.
    def UpdateAttributes(index, attrs, values, mva = false)
      Lib.sphinx_update_attributes(@sphinx, index, attrs.size, attrs, values.size, values.keys, values.values.flatten)
    end
  end
end