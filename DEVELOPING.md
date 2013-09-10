# Development

To work on the Liberty cookbook first ensure you have [Bundler][] installed.

```bash
$ gem install bundler
```

Next, use [Bundler][] to install Liberty cookbook dependencies:

```bash
$ bundle install
```

Finally, use [Rake][] to execute various tasks. For example:

```bash
$ rake all
```

[Bundler]: http://bundler.io/
[Rake]: http://rake.rubyforge.org/

# Testing

To check syntax of the cookbook files execute:

```bash
$ rake syntax
```

To run [Foodcritic][] (lint-like tool) on the cookbook execute:

```bash
$ rake foodcritic
```

To run [ChefSpec][] tests execute:

```bash
$ rake rspec
```

The tests and cookbooks used by [ChefSpec][] are located in the **spec/** directory. The [ChefSpec][] tests are quick.

To run [test-kitchen][] tests execute:

```bash
$ rake kitchen
```

The tests and cookbooks used by [test-kitchen][] are located in the **test/** directory. The [test-kitchen][] tests are slow as virtual machines are created and configured to run the tests. See [How to speed up 'test kitchen' tests](https://github.com/WASdev/ci.chef.wlp/wiki/How-to-speed-up-%27test-kitchen%27-tests) for ways to make it run faster.


[Foodcritic]: http://acrmp.github.io/foodcritic/
[ChefSpec]: http://acrmp.github.io/chefspec/
[test-kitchen]: https://github.com/opscode/test-kitchen

# Documentation

We use [knife-cookbook-doc][] tool to generate the `README.md` file which contains the cookbook documentation.
See the [knife-cookbook-doc][] tool documentation on details how to document the cookbook's attributes, recipes, and resources.
To regenerate the `README.md` file run the following command:

```bash
$ rake knife_doc
```

Don't forget to check-in and commit the modified `README.md` file.

[knife-cookbook-doc]: https://github.com/realityforge/knife-cookbook-doc

