# line-of-credit

To run the challenge scenarios:

```shell
bundle exec rspec spec/features/transactions_spec.rb
```

The scenarios manually call the close_period method which is meant to run at the end of the 30 day period. In reality these should be called by a job that is scheduled to run at the end of the period.

Since a user only has 1 account, I decided to reduce the complexity and just make the User keep track of it's account info.
    

