desc "Compile all assets named in config.assets.precompile, and show breakdown of their compilation speed"
task :'assets:precompile:profile' => ['assets:environment'] do
  if ENV['RAILS_GROUPS'].to_s.empty?
    puts " ! assets:precompile:profile failed: be sure to invoke this with"
    puts "   the assets group. Try:"
    puts ""
    puts "   $ rake assets:precompile:profile RAILS_GROUPS=assets"
    puts ""
    exit 1
  end

  module Sprockets
    class StaticCompiler
      # Re-implement #compile to measure the time it takes.
      def compile
        time, result = measure { do_compile }
        puts "Compilation finished in %ims." % [time]
        result
      end

      # Re-implement #compile to measuge the time and print it.
      def do_compile
        manifest = {}
        env.each_logical_path do |logical_path|
          if File.basename(logical_path)[/[^\.]+/, 0] == 'index'
            logical_path.sub!(/\/index\./, '.')
          end
          next unless compile_path?(logical_path)

          show = show_message?(logical_path)
          print "%-60s" % [logical_path] if show

          time, _ = measure {
            if asset = env.find_asset(logical_path)
              write_asset_to(asset, asset.logical_path)
              write_asset_to(asset, asset.digest_path) if @digest
              manifest[logical_path] = path_for(asset)
            end
          }

          puts "%ims" % [time] if show
        end

        write_manifest(manifest) if @manifest
      end

      # Re-implement write_asset to write to digest and local path simultaneously
      def write_asset_to(asset, path)
        filename = File.join(target, path)
        FileUtils.mkdir_p File.dirname(filename)
        asset.write_to(filename)
        asset.write_to("#{filename}.gz") if filename.to_s =~ /\.(css|js)$/
        path
      end

    private
      def compile_path?(logical_path)
        paths.each do |path|
          case path
          when Regexp
            return true if path.match(logical_path)
          when Proc
            return true if path.call(logical_path)
          else
            return true if File.fnmatch(path.to_s, logical_path)
          end
        end
        false
      end

      def show_message?(path)
        return true if ENV['VERBOSE'] || ENV['verbose']
        path =~ /\.(css|js)$/
      end

      def measure(&blk)
        t = Time.now
        output = yield
        [((Time.now - t) * 1000).to_i, output]
      end
    end
  end

  Rake::Task[:'assets:precompile:primary'].invoke
end
