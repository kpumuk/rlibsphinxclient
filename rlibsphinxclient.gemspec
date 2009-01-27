# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rlibsphinxclient}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dmytro Shteflyuk"]
  s.date = %q{2009-01-27}
  s.description = %q{A Ruby wrapper for pure C searchd client API library}
  s.email = %q{kpumuk@kpumuk.info}
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["CHANGELOG.rdoc", "ext/extconf.rb", "ext/rlibsphinxclient.i", "ext/rlibsphinxclient_wrap.c", "lib/sphinx/client.rb", "lib/sphinx/fast_client.rb", "lib/sphinx/request.rb", "lib/sphinx/response.rb", "lib/sphinx/safe_executor.rb", "lib/sphinx/timeout.rb", "lib/sphinx.rb", "LICENSE", "README.rdoc"]
  s.files = ["CHANGELOG.rdoc", "ext/extconf.rb", "ext/rlibsphinxclient.i", "ext/rlibsphinxclient_wrap.c", "init.rb", "lib/sphinx/client.rb", "lib/sphinx/fast_client.rb", "lib/sphinx/request.rb", "lib/sphinx/response.rb", "lib/sphinx/safe_executor.rb", "lib/sphinx/timeout.rb", "lib/sphinx.rb", "LICENSE", "Manifest", "Rakefile", "README.rdoc", "rlibsphinxclient.gemspec", "spec/client_response_spec.rb", "spec/client_spec.rb", "spec/fixtures/default_search.php", "spec/fixtures/default_search_index.php", "spec/fixtures/excerpt_custom.php", "spec/fixtures/excerpt_default.php", "spec/fixtures/excerpt_flags.php", "spec/fixtures/field_weights.php", "spec/fixtures/filter.php", "spec/fixtures/filter_exclude.php", "spec/fixtures/filter_float_range.php", "spec/fixtures/filter_float_range_exclude.php", "spec/fixtures/filter_range.php", "spec/fixtures/filter_range_exclude.php", "spec/fixtures/filter_ranges.php", "spec/fixtures/filters.php", "spec/fixtures/filters_different.php", "spec/fixtures/geo_anchor.php", "spec/fixtures/group_by_attr.php", "spec/fixtures/group_by_attrpair.php", "spec/fixtures/group_by_day.php", "spec/fixtures/group_by_day_sort.php", "spec/fixtures/group_by_month.php", "spec/fixtures/group_by_week.php", "spec/fixtures/group_by_year.php", "spec/fixtures/group_distinct.php", "spec/fixtures/id_range.php", "spec/fixtures/id_range64.php", "spec/fixtures/index_weights.php", "spec/fixtures/keywords.php", "spec/fixtures/limits.php", "spec/fixtures/limits_cutoff.php", "spec/fixtures/limits_max.php", "spec/fixtures/limits_max_cutoff.php", "spec/fixtures/match_all.php", "spec/fixtures/match_any.php", "spec/fixtures/match_boolean.php", "spec/fixtures/match_extended.php", "spec/fixtures/match_extended2.php", "spec/fixtures/match_fullscan.php", "spec/fixtures/match_phrase.php", "spec/fixtures/max_query_time.php", "spec/fixtures/miltiple_queries.php", "spec/fixtures/ranking_bm25.php", "spec/fixtures/ranking_none.php", "spec/fixtures/ranking_proximity_bm25.php", "spec/fixtures/ranking_wordcount.php", "spec/fixtures/retries.php", "spec/fixtures/retries_delay.php", "spec/fixtures/sort_attr_asc.php", "spec/fixtures/sort_attr_desc.php", "spec/fixtures/sort_expr.php", "spec/fixtures/sort_extended.php", "spec/fixtures/sort_relevance.php", "spec/fixtures/sort_time_segments.php", "spec/fixtures/sphinxapi.php", "spec/fixtures/update_attributes.php", "spec/fixtures/weights.php", "spec/sphinx/sphinx.conf", "spec/sphinx/sphinx_test.sql"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/kpumuk/rlibsphinxclient}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rlibsphinxclient", "--main", "README.rdoc"]
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = %q{rlibsphinxclient}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A Ruby wrapper for pure C searchd client API library}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
