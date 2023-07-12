### Base URL

`api.team5ecommerce.co/v1`

### Endpoints that are visible to all

#### Products

All products: `api.team5ecommerce.co/v1/products`
Available methods:
- GET : get all products

Get product by product_id: `api.team5ecommerce.co/v1.products/{product_id}`
Available methods:
- GET: get a product information

#### Categories

All categories: `api.team5ecommerce.co/v1/categories`
Available methods:
- GET

Get 1 category by category_id: `api.team5ecommerce.co/v1/categories/{category_id}`
Available methods:
- GET

#### Reviews
All reviews from a product by product_id: `api.team5ecommerce.co/v1/products/{product_id}/reviews`
Available methods:
- GET

### Endpoints that are visible to certain user

#### Orders

All orders of one user, using user_id: `api.team5ecommerce.co/v1/users/{user_id}/orders`
Available methods:
- GET: get all orders
- POST: create a new order

Order details from an order of a user, using user_id & order_id: `api.team5ecommerce.co/v1/users/{user_id}/orders/{order_id}`
Available methods:
- GET: get order details
- DELETE: cancel an order

#### Reviews

All reviews of one user, using user_id: `api.team5ecommerce.co/v1/users/{user_id}/reviews`
Available methods:
- GET: get all reviews

Get 1 review from a user, using user_id & review_id: `api.team5ecommerce.co/v1/users/{user_id}/reviews/{review_id}`
Available methods:
- GET: get 1 review
- PUT: edit/modiy a review
- DELETE: delete a review

#### User info

A user can see his/her own info, using user_id: `api.team5ecommerce.co/v1/users/{user_id}``
Available methods:
- GET: get an user information
- PUT: edit/modiy user information

### Endpoints that are restricted to admin only

#### Inventory

See inventory, using user_id where user_id matches users whose role is admin: `api.team5ecommerce.co/v1//user/{user_id=admin}/inventory`
Available methods:
- GET: get all inventory
- PUT: add new product into inventory, edit quantity

#### Users

Get all users, using user_id where user_id matches users whose role is admin: `api.team5ecommerce.co/v1//user/{user_id=admin}/users`
Available methods:
- GET: get all users
- POST: create new user

Get 1 user, using user_id where user_id matches users whose role is admin, and other user_id belongs to the user in request: `api.team5ecommerce.co/v1//user/{user_id=admin}/users/{user_id}`
Available methods:
- GET: get a user information
- PUT: edit a user information
- DELETE: delete a user

#### Products

All products: `api.team5ecommerce.co/v1/products`
Available methods:
- POST : create products, only admin can use this method

Product by product_id: `api.team5ecommerce.co/v1.products/{product_id}`
Available methods: 
- PUT: edit/modify product, only admin can use this method
- DELETE: delete a product, only admin can use this method

#### Categories

All categories: `api.team5ecommerce.co/v1/categories`
Available methods:
- POST: create a new category, only admin can use this method

Category by category_id: `api.team5ecommerce.co/v1/categories/{category_id}`
Available methods:
- PUT: edit category, only admin can use this method
- DELETE: delete a category, only admin can use this method

### Others

Check if email is available when register a new user: `api.team5ecommerce.co/v1/email-available`
Methods: [ POST ]