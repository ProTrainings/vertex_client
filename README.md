# VertexClient

[![Build Status](https://travis-ci.com/customink/vertex_client.svg?token=r6SdMyhouTa8X9zv834g&branch=master)](https://travis-ci.com/customink/vertex_client) [![Maintainability](https://api.codeclimate.com/v1/badges/f5c610d38dca05d7d8b6/maintainability)](https://codeclimate.com/repos/5be4865be81ccf2237014407/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/f5c610d38dca05d7d8b6/test_coverage)](https://codeclimate.com/repos/5be4865be81ccf2237014407/test_coverage)

The Vertex Client Ruby Gem provides an interface to integrate with _Vertex SMB_ which is also known as [Vertex Cloud Indirect Tax](https://www.vertexinc.com/solutions/products/vertex-cloud-indirect-tax).

## Usage

### Quotation

```ruby
response = VertexClient.quotation(
  # The top level transaction date for all line items.
  date: '2018-11-15',
  # The top level customer for all line items.
  customer: {
    code: "inky@customink.com",
    address_1: "11 Wall Street",
    address_2: "#300",
    city: "New York",
    state: "NY",
    postal_code: '10005',
    # Optional tax_exempt status for customer
    is_tax_exempt: true
  },
  # The top level seller for all line items.
  seller: {
    company: "CustomInk"
  },
  line_items: [
    {
      # Internal product ID or code
      product_code: "4600",
      # Mapped product class, or "commodity code", in Vertex Cloud
      product_class: "123456"
      quantity: 7,
      # Total price of this line item
      price: "35.50",
    },
    {
      product_code: "5200",
      product_class: "123456"
      quantity: 4,
      price: "25.40",
      # Optional transaction date override for a line item.
      date: '2018-11-14',
      # Optional seller override for a line item.
      seller: {
        company: "CustomInkStores"
      },
      # Optional customer override for a line item.
      customer: {
        code: "prez@customink.com",
        address_1: "1600 Pennsylvania Ave NW",
        city: "Washington",
        state: "DC",
        postal_code: '20500'
      }
    }
  ]
)

response.total_tax #=> Total tax amount
response.total     #=> Total price plus total tax
response.subtotal  #=> Total price before tax
```

### Invoice

Invoice is the same payload as quotation, but with one added identifier.

```ruby
VertexClient.invoice(
  # Vertex's Document Number is a unique referencial identifier for this invoice.
  document_number: "unique-identifier-1a43b",

  # ... All of the of the payload from quotation here ...
)

```

### Distribute Tax

Distribute Tax is the same payload as Invoice, but you pass `total_tax` on each line item. The `product_code` and `quantity` are optional.

```ruby
VertexClient.distribute_tax(

  # ...

  line_items: [
    {
      price: "100.00",
      total_tax: "6.00",
    }
  ]

)
```

### Adjustment Allocator

Allocates a given monetary adjustment, such as a service charge or a discount, across a given array of weights, such as line items. The `adjustment` parameter must be passed in as a positive or negative numeric dollar amount, such as `-0.56`, `7.00` or `12.34`, and the `weights` parameter must be passed in as an array of non-negative numeric values, such as `[1.23, 4.56, 7.89]` or `[1, 2, 3, 4]`, which can represent prices or ratios.

```ruby
VertexClient::Utils::AdjustmentAllocator.new(1234.56, [310.00, 350.00, 200.00, 140.00]).allocate
#=> [#<BigDecimal:7fa6bba053c0,'0.38271E3',18(36)>,
     #<BigDecimal:7fa6bba0fcd0,'0.4321E3',18(36)>,
     #<BigDecimal:7fa6bba0dfc0,'0.24691E3',18(36)>,
     #<BigDecimal:7fa6bba17b88,'0.17284E3',18(36)>]
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vertex_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vertex_client

## Configuration

Configure the client's connection to Vertex using environment variables or an initializer.

### Environment Variables
The following environment variables are used to configure the client.

```
VERTEX_TRUSTED_ID=your-trusted-id
VERTEX_SOAP_API=https://connect.vertexsmb.com/vertex-ws/services/CalculateTax70
```
### Initializer

If you are using Rails, take advantage of the included generator:

    $ bundle exec rails g vertex_client:install

Otherwise reference our [initializer template](https://github.com/customink/vertex_client/blob/master/lib/generators/install/templates/initializer.rb.erb)


## Development

This project follows Github's [Scripts to rule them all conventions][scripts-to-rule-them-all]. After cloning the app,
run the following:

    bin/bootstrap
    bin/setup
    bin/test

After pulling down changes, run the following:

    bin/update

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/customink/vertex_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the VertexClient project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/customink/vertex_client/blob/master/CODE_OF_CONDUCT.md).

[scripts-to-rule-them-all]: https://github.com/github/scripts-to-rule-them-all
