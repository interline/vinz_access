# Vinz Access

A users and groups permission based framework.

## Motivation

A system is built of resources. According to Vinz Access, resources can be
created, read (searched), updated, deleted. System users should only be able
to access certain resources (Vendor, Invoice, Sales Order, Follow Up Report,
etc) pertaining to a job function. Additionally, system users may only be able
to manipulate specific records or a given resource (*my* Customers as opposed
to *all* customers) pertaining to a job function.

The same job function may be performed by multiple users (ex. process accounts
payable). Some users may perform multiple job functions (ex. process accounts
payable and maintain vendor contact information).

Vinz Access facilitates access control to resources via users, groups, access
rights and access filters.

### Users

A user represents a person who can log on to the system and do work.

### Groups

A group is a collection of users. Users obtain access to resources
according to their group membership.

### Access Rights

Access rights are used to grant crud access on a given class resource objects
(ex. *all* sales orders). Access rights can be global (for all users) or can
be assigned to a group.

### Access Filters

The only difference between an access filter and an access right is that an
access filter constrains the access rights to a subset of records (domain).
The domain of a filter is defined in elixir syntax and is compiled to a
quoted term which will be accessbile to calling functions. Calling functions
will have to interpret the quoted term according to its use case. For example,
an access filter with `read` access and the following domain
`customer.first_name == user.first_name` would grant read access to only those
customer records that have the same first name as the logged on user. Contrived,
true. But I hope you get the point.

Implementors are free to choose the symantics of objects/records in the domain
rules.

## Usage

```elixir

defmodule MyResource do
  @resource "Resource X"

  def read(user_id, filters // []) do
    Access.permit user_id, @resource, :read, fn(domain) ->
      "select * from resource_x_table"
        |> apply_filters(filters)
        |> apply_domain_filters(domain)
        |> execute
    end
  end
end
```

**TODO** Provide an example of consuming a quoted domain term

## Configuration

Uh...working on the UI.
Would be nice to have a way to slurp in config
