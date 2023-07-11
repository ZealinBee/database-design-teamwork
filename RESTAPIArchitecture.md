# REST API Architecture

FAKE API LINK: api.team5ecommerce.co/v1

## USERS

### Create a user

You can create a new user by sending an object like the following to ``/users``

Request:

    [POST] api.team5ecommerce.co/v1/users
    # Body
    {
        "first_name": "Nicolas",
        "last_name": "Nicolas",
        "image": "https://api.lorem.space/image/face?w=640&h=480&r=867",
        "password": "1234",
        "email": "nico@gmail.com",
        "phone": "1234567890",
        "address": "Street Name 32",
        "is_admin": "false",
    }

Response:

    {
        "first_name": "Nicolas",
        "last_name": "Nicolas",
        "image": "https://api.lorem.space/image/face?w=640&h=480&r=867",
        "password": "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4",
        "email": "nico@gmail.com",
        "phone": "1234567890",
        "address": "Street Name 32",
        "is_admin": "false",
        "id": 1
    }

### Get a single user

You can get a single user by adding the id as a parameter: ``/users/{id}``

Request:

    [GET] api.team5ecommerce.co/v1/users/1

Response:

    {
        "id": 1
        "first_name": "Nicolas",
        "last_name": "Nicolas",
        "image": "https://api.lorem.space/image/face?w=640&h=480&r=867",
        "password": "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4",
        "email": "nico@gmail.com",
        "phone": "1234567890",
        "address": "Street Name 32",
        "is_admin": "false",
    }

### Update a user

You can update a user exists by sending an object like the following and adding the id as a parameter: ``/users/{id}``

Request:

    [PUT] api.team5ecommerce.co/v1/users/1
    # Body
    {
        "first_name": "New",
        "last_name": "Name",
        "image": "https://api.lorem.space/image/face?w=640&h=480&r=867",
        "password": "12345",
        "email": "newemail@gmail.com",
        "phone": "1234567890",
        "address": "New Street Av 14",
    }

Response:

    {
        "id": 1,
        "first_name": "New",
        "last_name": "Name",
        "image": "https://api.lorem.space/image/face?w=640&h=480&r=867",
        "password": "5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5",
        "email": "newemail@gmail.com",
        "phone": "1234567890",
        "address": "New Street Av 14",
        "is_admin": "false",
    }

### Delete a user

You can delete a user by adding the id as a parameter: ``/users/{id}``

Request:

    [DELETE] api.team5ecommerce.co/v1/users/1

Response:

    true 

### Get all users as admin

You can access the list of 3 users by using the ``/users/:userId=admin/users`` endpoint.

Request:

    [GET] api.team5ecommerce.co/v1/users/:userId=admin/users

Response:

    [
        {
            "id": 1,
            "first_name": "Nicolas",
            "last_name": "Nicolas",
            "image": "https://api.lorem.space/image/face?w=640&h=480&r=867",
            "password": "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4",
            "email": "nico@gmail.com",
            "phone": "1234567890",
            "address": "Street Name 32",
            "is_admin": "false",
        },
        // ...
    ]

### Create a user as admin

You can create a new user by sending an object like the following to ``/users/:userId=admin/users``

Request:

    [POST] api.team5ecommerce.co/v1/users/:userId=admin/users
    # Body
    {
        "first_name": "Nicolas",
        "last_name": "Nicolas",
        "image": "https://api.lorem.space/image/face?w=640&h=480&r=867",
        "password": "1234",
        "email": "nico@gmail.com",
        "phone": "1234567890",
        "address": "Street Name 32",
        "is_admin": "false",
    }

Response:

    {
        "first_name": "Nicolas",
        "last_name": "Nicolas",
        "image": "https://api.lorem.space/image/face?w=640&h=480&r=867",
        "password": "1234",
        "email": "nico@gmail.com",
        "phone": "1234567890",
        "address": "Street Name 32",
        "is_admin": "false",
        "id": 1
    }

### Get a single user as admin

You can get a single user by adding the id as a parameter: ``/users/{id}``

Request:

    [GET] api.team5ecommerce.co/v1/user/:userId=admin/users/1

Response:

    {
        "id": 1
        "first_name": "Nicolas",
        "last_name": "Nicolas",
        "image": "https://api.lorem.space/image/face?w=640&h=480&r=867",
        "password": "1234",
        "email": "nico@gmail.com",
        "phone": "1234567890",
        "address": "Street Name 32",
        "is_admin": "false",
    }

### Update a user as admin 

You can update a user exists by sending an object like the following and adding the id as a parameter: ``/users/:userId=admin/users/{id}``
Request:

    [PUT] api.team5ecommerce.co/v1/users/:userId=admin/users/1
    # Body
    {
        "first_name": "New",
        "last_name": "Name",
        "image": "https://api.lorem.space/image/face?w=640&h=480&r=867",
        "password": "12345",
        "email": "newemail@gmail.com",
        "phone": "1234567890",
        "address": "New Street Av 14",
        "is_admin": "true",
    }

Response:

    {
        "id": 1,
        "first_name": "New",
        "last_name": "Name",
        "image": "https://api.lorem.space/image/face?w=640&h=480&r=867",
        "password": "12345",
        "email": "newemail@gmail.com",
        "phone": "1234567890",
        "address": "New Street Av 14",
        "is_admin": "true",
    }

### Delete a user as admin

You can delete a user by adding the id as a parameter: ``/users/:userId=admin/users/{id}``

Request:

    [DELETE] api.team5ecommerce.co/v1/users/:userId=admin/users/1

Response:

    true 

### Check the email

You can verify if an email is already registered in the API by adding the parameter: ``/users/is-available``

Request:

    [POST] api.team5ecommerce.co/v1/users/is-available  
    # Body
    {
        "email": "newestemail@mail.com",
    }

Response:

    {
        "isAvailable": true
    }

## PRODUCTS

### Get all products

You can access the list of 200 products by using the ``/products`` endpoint.

Request:

    [GET] api.team5ecommerce.co/v1/products

Response:

    [
        {
            "id": 4,
            "name": "Handmade Fresh Table",
            "image": "https://placeimg.com/640/480/any?r=0.9178516507833767"
            "price": 687,
            "description": "Greate round ancient table",
            "category": {
            "id": 1,
            "name": "Furniture",
            },
        }
        // ...
    ]

### Create a product

You can create a new product by sending an object like the following to ``/products``

Request:

    [POST] api.team5ecommerce.co/v1/products
    # Body
    {
        "name": "New Product",
        "image": "https://placeimg.com/640/480/any"
        "price": 10,
        "description": "A description",
        "categoryId": 3,
    }

Response:

    {
        "name": "New Product",
        "image": "https://placeimg.com/640/480/any",
        "price": 10,
        "description": "A description",
        "category": {
            "id": 3,
            "name": "Clothes",
        },
        "id": 210,
    }

### Get a single product

You can get a single product by adding the id as a parameter: ``/products/{id}``

Request:

    [GET] api.team5ecommerce.co/v1/products/3

Response:

    {
        "id": 3,
        "title": "Clown Shoe",
        "images": "https://placeimg.com/640/480/any?r=0.9178516507833767"
        "price": 12,
        "description": "Amazing shoe",
        "category": {
            "id": 2,
            "name": "Cloting"
        },
    }

### Update a product

You can update a product by sending an object like the following and adding the id as a parameter: ``/products/{id}``

Request:

    [PUT] api.team5ecommerce.co/v1/products/1
    # Body
    {
        "title": "Change title",
        "price": 100
    }

Response:

    {
        "id": 1,
        "title": "Change title",
        "image": "https://placeimg.com/640/480/any",
        "price": 100,
        "description": "The automobile layout consists of a front-engine design, with transaxle-type transmissions mounted at the rear of the engine and four wheel drive",
        "category": {
            "id": 2,
            "name": "Cloting"
        }
    }

### Delete a product

You can delete a product by adding the id as a parameter: ``/products/{id}``

Request:

    [DELETE] api.team5ecommerce.co/v1/products/1

Response:

    true

### Pagination

APIs that use offset-based paging use the offset and limit query parameters to paginate through items in a collection.

Offset-based pagination is often used where the list of items is of a fixed and predetermined length.

To fetch the first page of entries in a collection, the API needs to be called with the offset set to 0 and the limit the products that you want in the response.

Request:

    [GET] api.team5ecommerce.co/v1/products?offset=0&limit=10

Response:

    [
        {
            "id": 1,
            "title": "Handmade Fresh Table",
            "price": 687,
            "description": "Andy shoes are designed to keeping in...",
            "category": {
            "id": 5,
            "name": "Others",
            "image": "https://placeimg.com/640/480/any?r=0.591926261873231"
            },
            "images": [
            "https://placeimg.com/640/480/any?r=0.9178516507833767",
            "https://placeimg.com/640/480/any?r=0.8807778235430017"
            ]
        }
        // ... and 9 items more
    ]

To fetch the next page of entries, the API needs to be called with an offset parameter that equals the sum of the previous offset value and limit returned to the previous result,

To get the next page of entries, use an offset parameter equal to the sum of the previous offset value and the limit returned to the previous result, previous_offset + previous_limit.

[GET] api.team5ecommerce.co/v1/products/:productId/reviews

## CATEGORIES

### Get all categories

You can access the list of 5 categories by using the ``/categories`` endpoint.

Request:

    [GET] api.team5ecommerce.co/v1/categories

Response:

    [
        {
            "id": 1,
            "name": "Clothes",
        }
        // ...
    ]

### Create a category

You can create a new category by sending an object like the following to ``/categories``

Request:

    [POST] api.team5ecommerce.co/v1/categories
    # Body
    {
        "name": "New Category",
    }

Response:

    {
        "name": "New Category",
        "id": 6
    }

### Get a single category

You can get a single category by adding the id as a parameter: ``/categories/{id}``

Request:

    [GET] api.team5ecommerce.co/v1/categories/1

Response:

    {
        "id": 1,
        "name": "Clothes",
    }

### Update a category

You can update a category exists by sending an object like the following and adding the id as a parameter: ``/categories/{id}``

Request:

    [PUT] api.team5ecommerce.co/v1/categories/3
    # Body
    {
        "name": "Change title"
    }

Response:

    {
        "id": 3,
        "name": "Change title",
    }

### Delete a category

You can delete a category by adding the id as a parameter: ``/categories/{id}``

Request:

    [DELETE] api.team5ecommerce.co/v1/categories/2

Response:

    true 

### Get all products by category

You can get the products by category adding the categoryID as a parameter to ``/categories/{id}/products``

Request:

    [GET] api.team5ecommerce.co/v1/categories/1/products

Response:

    [
        {
            "id": 4,
            "title": "Handmade Fresh Table",
            "images": "https://placeimg.com/640/480/any?r=0.9178516507833767"
            "price": 687,
            "description": "Andy shoes are designed to keeping in...",
            "category": {
            "id": 1,
            "name": "Others",
            },
        }
        // ...
    ]

## ORDERS

### Get all order from one user

You can access the order of a user by using the ``/user/{id}/orders`` endpoint.

Request:

    [GET] api.team5ecommerce.co/v1/user/1/orders

Response:

    [
        {
            "order_id": 1,
            "user_id": 1,
            "order_details": {
            "order_id": 1,
            "product_id": "Shoes",
            "product_quantity": "1",
            },
            {
            "order_id": 1,
            "product_id": "Gum",
            "product_quantity": "5",
            },
        }
        // ...
    ]

### Create a order

You can create a new order by sending an object like the following to ``/users/{id}/orders``

Request:

    [POST] api.team5ecommerce.co/v1/users/1/orders
    # Body
    {
        {
            "user_id": 1,
            "order_details": {
            "order_id": 2,
            "product_id": "Chair",
            "product_quantity": "4",
            },
            {
            "order_id": 2,
            "product_id": "Table",
            "product_quantity": "1",
            },
        }
    }

Response:

    {
        "user_id": 1,
            "order_details": {
            "order_id": 2,
            "product_id": "Chair",
            "product_quantity": "4",
            },
            {
            "order_id": 2,
            "product_id": "Table",
            "product_quantity": "1",
            },
        "order_id": 2,
    }

### Get all order detail from a single order

You can access the order detail of a single order by using the ``/users/{id}/orders/{id}`` endpoint.

Request:

    [GET] api.team5ecommerce.co/v1/users/1/orders/1

Response:

    {
        "order_details": {
            "order_id": 1,
            "product_id": "Shoes",
            "product_quantity": "1",
        },
        {
            "order_id": 1,
            "product_id": "Gum",
            "product_quantity": "5",
        },
    }

### Cancel an order

You can cancel an order by adding the id as a parameter: ``/users/{id}/orders/{id}``

Request:

    [DELETE] api.team5ecommerce.co/v1/users/1/orders/2

Response:

    true 

## INVENTORY

### Get all products in inventory

You can access the inventory by using the ``/users/:userId=admin/inventory``

Request:

    [GET] api.team5ecommerce.co/v1/users/:userId=admin/inventory

Response:

    [
        {
            "product_id": 1,
            "quantity": "26"
        }
        // ...
    ]

### Add product to inventory

You can add a product to inventory by sending an object like the following to ``/users/:userId=admin/inventory``

Request:

    [POST] api.team5ecommerce.co/v1/users/:userId=admin/inventory
    # Body
    {
        "product_id": 4,
        "quantity": "9"
    }

Response:

    {
        "product_id": 4,
        "quantity": "9"
    }

### Get a single product in inventory

You can get a single product in inventory by adding the id as a parameter: ``/products/{id}``

Request:

    [GET] api.team5ecommerce.co/v1/users/:userId=admin/inventory/4

Response:

    {
        "product_id": 4,
        "quantity": "9"
    }

### Update a product in inventory
 
You can update a product by sending an object like the following and adding the id as a parameter: ``/users/:userId=admin/inventory/{id}``

Request:

    [PUT] api.team5ecommerce.co/v1/users/:userId=admin/inventory/16
    # Body
    {
        "product_id": 16,
        "quantity": "7"
    }

Response:

    {
        "product_id": 16,
        "quantity": "7"
    }


### Delete a product in inventory

You can delete a product by adding the id as a parameter: ``/users/:userId=admin/inventory/{id}``

Request:

    [DELETE] api.team5ecommerce.co/v1/users/:userId=admin/inventory/2

Response:

    true

## REVIEWS
