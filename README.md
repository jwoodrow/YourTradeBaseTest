# YourTradeBase Technical Test
## How to run tests
```bash
> git clone git@github.com:jwoodrow/YourTradeBaseTest.git
```

or

```bash
> git clone https://github.com/jwoodrow/YourTradeBaseTest.git
```

```bash
> cd YourTradeBaseTest
> bundle install
> rspec spec
```

## How to run exercices
### As an executable
Locate your ruby binary:

```bash
> which ruby
#=> /path/to/your/ruby/binary
```

edit both exercices `list_people_at_100km_or_less.rb` and `average_value_at_200km_or_less.rb`

replace this:

```ruby
#!/Users/feilsafe/.rvm/rubies/ruby-2.5.3/bin/ruby
```

with your ruby path:

```ruby
#!/path/to/your/ruby/binary
```

```bash
> chmod +x list_people_at_100km_or_less.rb average_value_at_200km_or_less.rb
> ./list_people_at_100km_or_less.rb path_to_json_file
> ./average_value_at_200km_or_less.rb path_to_json_file
```

### Using ruby

```bash
> ruby list_people_at_100km_or_less.rb path_to_json_file
> ruby average_value_at_200km_or_less.rb path_to_json_file
```
