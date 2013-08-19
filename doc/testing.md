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

