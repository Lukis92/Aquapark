# Rails 8.1 calls .to_h on ActionController::Parameters when passed to named
# URL helpers (route_set.rb define_url_helper). This raises
# ActionController::UnfilteredParameters for unpermitted params.
# Using to_unsafe_h is safe here because URL helpers only build strings.
ActionDispatch::Routing::RouteSet::NamedRouteCollection.prepend(
  Module.new do
    private

    def define_url_helper(mod, name, helper, url_strategy)
      mod.define_method(name) do |*args|
        last = args.last
        options =
          case last
          when Hash
            args.pop
          when ActionController::Parameters
            args.pop.to_unsafe_h
          end
        helper.call(self, name, args, options, url_strategy)
      end
    end
  end
)
