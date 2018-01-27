# Servicer

Simple Service Object builder.

## Installation

```
gem install servicer
```

## Basic usage

Servicer provides base class for building services, and set of additional layers for changing behaviour.

Simplest use case is building Command Object for API:

```
class CreateUser < ::Servicer::Base
  def call(current_user, params)
    User.create(params)
  end
end

CreateUser.call(current_user, params) #=> new User
```

In that form no layers are applied, so input will not be changed in any way. Servicer is proxying class `call` method,
building new instance and calling `call` with the same params as provided (unless modified by layers).

## Layers

Layers are modifying how given service object behave. They can validate input, change params, and raise errors.
Simplest call would look like this:

```
class CreateUser < ::Servicer::Base
  layer :require_user

  def call(current_user, params)
    User.create(params)
  end
end
```

Multiple layers can be applied and they will be executed in order of mentioning them. Some of them will require
additional parameters, documentation can be found below.

### RequireUser

This layer is raising `Servicer::AuthorizationError` is current user is not provided. This layer is not accepting
any options.

```
class CreateUser < ::Servicer::Base
  layer :require_user

  def call(current_user, params)
    User.create(params)
  end
end

CreateUser.call(nil, params) #=> raises Servicer::AuthorizationError
```

### SetDefaultParams

This layer is merging received params with default values provided using deep merge (nested hash values will be merged).
Values from provided params always take precedence over default values.

```
class CreateUser < ::Servicer::Base
  layer :set_default_values, {
    role: 'user'
  }

  def call(current_user, params)
    User.create(params)
  end
end

CreateUser.call(nil, {}) #=> user.role == 'user'
CreateUser.call(nil, { role: 'admin' }) #=> user.role == 'admin'
```

### ValidateParams

This layer is validating params provided, raising `Servicer::ParamsError` if validation fails, and filtering any param
that was not validated. It's using [dry-validation](http://dry-rb.org/gems/dry-validation/) under the hood, and you need
to include it in your Gemfile.

Please bear in mind that it's used for validating input, and not for checking user permissions.

```
class CreateUser < ::Servicer::Base
  layer :validate_params do
    required(:role).filled(:str?)
    optional(:age).filled(:int?, gt?: 17)
  end

  def call(current_user, params)
    User.create(params)
  end
end

CreateUser.call(nil, {}) #=> raises Servicer::ParamsError
CreateUser.call(nil, { role: 1 }) #=> raises Servicer::ParamsError
CreateUser.call(nil, { role: 'admin' }) #=> user.role == 'admin'
CreateUser.call(nil, { role: 'admin', age: 17 }) #=> raises Servicer::ParamsError
CreateUser.call(nil, { role: 'admin', age: 18 }) #=> user.role == 'admin', user.age == 18
```

## Combining layers

Multiple layers can be used together in order to provide final service:

```
class CreateUser < ::Servicer::Base
  layer :require_user

  layer :validate_params do
    optional(:role).filled(:str?)
    required(:age).filled(:int?, gt?: 17)
  end

  layer :set_default_values, {
    role: 'user'
  }

  def call(current_user, params)
    User.create(params)
  end
end
```

```
class ListUsers < ::Servicer::Base
  layer :validate_params do
    optional(:role).filled(:str?)
    optional(:limit).filled(:int?, gt?: 0, lt?: 1000)
    optional(:offset).filled(:int?)
  end

  layer :set_default_values, {
    limit: 10,
    offset: 0
  }

  def call(current_user, params)
    limit = params.delete(:limit)
    offset = params.delete(:offset)
    User.where(params).limit(limit).offset(offset)
  end
end
```

## License

(The MIT License)

Copyright © 2018 Bernard Potocki

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
