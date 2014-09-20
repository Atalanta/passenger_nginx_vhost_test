# passenger_nginx_vhost_test

This is a simple cookbook designed to test the `passenger_nginx_vhost` LWRP which is exposed by the `passenger_nginx` cookbook.

To run ChefSpec tests, simply run:

    rspec -fd --color

To run ServerSpec tests (via KitchenCI), simply run:

    kitchen test

This explictly only tests Ubuntu 14.04, as this is the only platform which the `passenger_nginx` currently supports.

