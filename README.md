Setup
==

```
$ brew update
$ brew install carthage
$ carthage bootstrap --platform iOS (to avoid updating dependencies)
$ carthage update --platform iOS (same as above but also updates all the dependencies)
```

API
==
All requests must set:

`Content-Type: application/json`

## URI: POST /api/sign_in
Request Body:

`{ email: "<email address>", password: "<password>" }`

Response:
```
{
  "user_id":295,
  "auth_token":"vsw8Ek4SHeJMCZ4-rKKa"
}
```

*NOTE:* Once you receive an 'auth_token' you must pass it in subsequent API calls in the `X-Freightroll-Token` header. E.g. `X-Freightroll-Token: vsw8Ek4SHeJMCZ4-rKKa`.

## URI: GET /api/shipments/accepted
*NOTE:* This endpoint is not implemented yet. It currently exists as /api/shipments.
This be the list of shipments that you've accepted and have NOT been completed yet

## URI: GET /api/shipments/posted
*NOTE:* This endpoint is not implemented yet. It currently exists as /api/shipments/live.
This is the list of shipments that are available for you to choose to accept.

## URI: GET /api/shipments/:id
*Note:* The json format here is what is to be expected in any of the endpoints that return an array-of-shipments.

Response:
```
{
    "commodity": "apparel",
    "distance": 659,
    "dropoff": {
        "address": "1 Cedar Point Dr",
        "address2": null,
        "appointment_needed": true,
        "city": "Sandusky",
        "company_name": "Trantow-Moen",
        "contact_person": "Ms. Jules Kessler",
        "date": "2018-01-05T00:00:00.000-05:00",
        "geofencing": {
            "geofencing_radius": 500.0,
            "on_enter": {
                "alert": "message to display when geofencing triggered",
                "link": "custom scheme link to controller/view or http link",
                "payload": "extended data dependent on 'link'",
                "sound": "default"
            },
            "on_exit": {
                "alert": "message to display when geofencing triggered",
                "link": "custom scheme link to controller/view or http link",
                "payload": "extended data dependent on 'link'",
                "sound": "default"
            }
        },
        "lat": "41.4843767",
        "latest_date": "2018-01-05T01:15:00.000-05:00",
        "lon": "-82.6829312",
        "other_instructions": "Aliquam et molestiae id autem corporis. Sapiente illum nihil aut possimus. Molestiae aliquid et hic sunt aut corporis. Ea adipisci quos sequi maiores nobis rem dolore. Sit ut error accusantium consectetur beatae occaecati.\\r\\nIn sed inventore et ut quidem sit accusantium. Sint dolorem in. Qui quae ipsam consequatur consequuntur deleniti. Commodi officiis aut a. Quo rem minus dolorum et necessitatibus autem.\\r\\nUnde iure ullam optio omnis eius cumque alias. Sed neque dolorem quas corporis aut. Dolore qui quis molestiae et accusamus aut voluptatem. Nesciunt aut molestiae porro voluptas similique. Aperiam maxime fugiat.",
        "phone": "3023084858",
        "state": "OH",
        "zip_code": "44870"
    },
    "id": 1406,
    "pickup": {
        "address": "24 Willie Mays Plaza",
        "address2": null,
        "appointment_needed": true,
        "city": "San Francisco",
        "company_name": "Mraz-Walker",
        "contact_person": "Audreanne Bernier",
        "date": "2017-12-27T00:00:00.000-05:00",
        "geofencing": {
            "geofencing_radius": 500.0,
            "on_enter": {
                "alert": "message to display when geofencing triggered",
                "link": "custom scheme link to controller/view or http link",
                "payload": "extended data dependent on 'link'",
                "sound": "default"
            },
            "on_exit": {
                "alert": "message to display when geofencing triggered",
                "link": "custom scheme link to controller/view or http link",
                "payload": "extended data dependent on 'link'",
                "sound": "default"
            }
        },
        "lat": "37.7785351",
        "latest_date": "2017-12-27T01:15:00.000-05:00",
        "lon": "-122.3894833",
        "other_instructions": "Nesciunt tempore est rerum aut facere. Ea sit nihil. Consequatur non aperiam. Recusandae rem quis consequatur qui quo. Dolore velit mollitia nesciunt nihil rerum.\\r\\nMinus consequatur harum quo. Sed sed rerum officia aspernatur ipsum. Quo similique et eos non quos.\\r\\nAmet modi rerum ducimus iusto nisi atque. Soluta quo non. Repellendus dolores sed voluptatem.",
        "phone": "6194233935",
        "state": "CA",
        "zip_code": "94107"
    },
    "rate": "910.00",
    "status": "wizzard_finished",
    "truck_type": "flatbed",
    "weight": 43574
}
```

## URI: GET /api/shipments?status=<status>&truck_type=<truck type>&commodity=<commodity>&company=<company name>&shipment_id=<shipment_id>&pick_up_city=<pickup city>&pick_up_state=<pickup state>&drop_off_city=<dropoff city>&drop_off_state=<dropoff state>
+ *NOTE:* The following endpoint will be replaced by /api/shipments/accepted
+ *NOTE:* There is some code that will give you possible values for query params above. Not sure if it would be better to expose that or limit the things you can query on (HATEOS-ish).

Response:
```
[
    {
        "commodity": "apparel",
        "distance": 767,
        "dropoff": {
            "city": "Orlandoberg",
            "date": "2017-10-24T00:00:00.000-04:00",
            "latest_date": "2017-10-24T02:30:00.000-04:00",
            "state": "ID",
            "zip_code": "59171-2920"
            "lat": "41.4843767",
            "lon": "-82.6829312",
        },
        "id": 1231,
        "pickup": {
            "city": "Hectormouth",
            "date": "2017-10-26T00:00:00.000-04:00",
            "latest_date": "2017-10-26T04:45:00.000-04:00",
            "state": "IL",
            "zip_code": "13287"
            "lat": "41.4843767",
            "lon": "-82.6829312",
        },
        "rate": "705.00",
        "truck_type": "dry_van",
        "weight": 40117
    },
    {
        "commodity": "appliances",
        "distance": 2395,
        "dropoff": {
            "city": "Hamtramck",
            "date": "2017-10-20T07:00:00.000-04:00",
            "latest_date": "2017-10-20T16:00:00.000-04:00",
            "state": "MI",
            "zip_code": "48212"
            "lat": "41.4843767",
            "lon": "-82.6829312",
        },
        "id": 1223,
        "pickup": {
            "city": "San Francisco",
            "date": "2017-10-16T07:00:00.000-04:00",
            "latest_date": "2017-10-16T16:00:00.000-04:00",
            "state": "CA",
            "zip_code": "94107"
            "lat": "41.4843767",
            "lon": "-82.6829312",
        },
        "rate": "3970.00",
        "truck_type": "flatbed",
        "weight": 47993
    },
    {
        "commodity": "apparel",
        "distance": 1757,
        "dropoff": {
            "city": "New Alexannebury",
            "date": "2017-10-18T00:00:00.000-04:00",
            "latest_date": "2017-10-18T00:00:00.000-04:00",
            "state": "AR",
            "zip_code": "48104"
            "lat": "41.4843767",
            "lon": "-82.6829312",
        },
        "id": 1220,
        "pickup": {
            "city": "Noelberg",
            "date": "2017-10-22T00:00:00.000-04:00",
            "latest_date": "2017-10-22T00:45:00.000-04:00",
            "state": "IL",
            "zip_code": "48104"
            "lat": "41.4843767",
            "lon": "-82.6829312",
        },
        "rate": "1290.00",
        "truck_type": "flatbed",
        "weight": 20005
    }
]
```

## URI: GET /api/user

Response:
```
{
    "about_me": null,
    "billing_info": {
        "address": "123 Main St.",
        "city": "San Francisco",
        "company_name": "Freightroll",
        "contact_person": "Nick Forte",
        "email": "nick+shipper@freightroll.com",
        "phone": "5555555555",
        "phone_ext": "1234",
        "state": "CA",
        "zip_code": "94107"
    },
    "business_info": {
        "address": "618 S. Main St.",
        "city": "Ann Arbor",
        "company_name": "Freightroll LLC",
        "contact_person": "Nick Forte",
        "email": "nick+shipper@freightroll.com",
        "phone": "9172975502",
        "phone_ext": "5432",
        "state": "MI",
        "zip_code": "48104"
    },
    "personal_info": {
        "address": null,
        "city": null,
        "company_name": "Freightroll",
        "email": "nick+shipper@freightroll.com",
        "phone": "",
        "phone_ext": null,
        "state": null,
        "zip_code": null
    },
    "email": "nick+shipper@freightroll.com",
    "first_name": "Nick",
    "id": 295,
    "image_url": "fallback/avatar.png",
    "last_name": "Forte",
    "phone": "",
    "phone_ext": null
}
```

## URI: PUT /api/user/location
Request Body:

```
{ lat: "45.708", lng: "79.223" }
```

Response:

Returns 204 No Content on success

## URI: POST /api/shipments/:id/accept
Request Body:

```
{ lat: "45.708", lng: "79.223" }
```

Response:

Returns shipment object

## URI: POST /api/shipments/:id/delivered
Request Body:

```
{ lat: "45.708", lng: "79.223" }
```

Response:

Returns shipment object

+ If shipment has already been delivered, a 409 is returned.
+ *NOTE:* It might make sense to return a 400 instead.

## URI: POST /api/shipments/:id/pick_up
Request Body:

```
{ lat: "45.708", lng: "79.223" }
```

Response:

Returns shipment object

+ If shipment has already been picekd up, a 409 is returned.
+ *NOTE:* It might make sense to return a 400 instead.

URI: GET /api/shipments/:id/collaboration
-----
*NOTE:* The `id` is the same as the chatroom_id anywhere else. The naming is just inconsistent.
The `messages` array is ordered in time ascending. To make things easier for you, I can denormalize the users in the `users` array into the `message` object. Just let me know if I should.
The `name` attribute will probably removed. It's not used for anything now and we haven't found a use for it.
The `post_url` attribute is where you do POST for sending a message. For the websocket piece, here is the protocol we are using: https://github.com/danielrhodes/Swift-ActionCableClient. It would be quicker for you to use a library that already exists and uses the ActionCable protocol rather than me document the full spec. Lastly, you establish an ActionCable consumer by opening a websocket connection to `wss_url`?token=<auth_token>.

TBD: Right now, all `messages` are returned. In the future, this will be a paginated response. But that's something for the future.

The websocket receives a `data` payload where the json format looks like:
```
{
  chatroom_id: integer,
  display_name: string,
  created_at: datetime,
  message: string
}
```

Response:
```
{
    "created_at": "2017-10-21T13:04:31.409-04:00",
    "id": 3,
    "post_url": "https://freightroll-collaboration.herokuapp.com/chatrooms/3/messages",
    "wss_url": "wss://freightroll-collaboration.herokuapp.com/cable",
    "messages": [
        {
            "body": "dflkjfd",
            "created_at": "2017-10-21T13:09:28.770-04:00",
            "id": 9,
            "updated_at": "2017-10-21T13:09:28.770-04:00",
            "user_id": 285
        },
        {
            "body": "how's it going?",
            "created_at": "2017-10-21T13:14:19.022-04:00",
            "id": 10,
            "updated_at": "2017-10-21T13:14:19.022-04:00",
            "user_id": 285
        },
        {
            "body": "lkjfdalkd",
            "created_at": "2017-10-21T13:25:30.400-04:00",
            "id": 11,
            "updated_at": "2017-10-21T13:25:30.400-04:00",
            "user_id": 285
        },
        {
            "body": "dflkj",
            "created_at": "2017-10-21T17:26:55.552-04:00",
            "id": 24,
            "updated_at": "2017-10-21T17:26:55.552-04:00",
            "user_id": 285
        },
        {
            "body": "dslkfajdf",
            "created_at": "2017-10-21T17:44:33.649-04:00",
            "id": 25,
            "updated_at": "2017-10-21T17:44:33.649-04:00",
            "user_id": 285
        },
        {
            "body": "alkdfj;ds",
            "created_at": "2017-10-21T17:44:35.012-04:00",
            "id": 26,
            "updated_at": "2017-10-21T17:44:35.012-04:00",
            "user_id": 285
        },
        {
            "body": "dlksajfdsl",
            "created_at": "2017-10-21T17:44:41.130-04:00",
            "id": 27,
            "updated_at": "2017-10-21T17:44:41.130-04:00",
            "user_id": 285
        }
    ],
    "name": null,
    "shipment_id": 1152,
    "updated_at": "2017-10-21T13:04:31.409-04:00",
    "users": [
        {
            "display_name": "Carrier One",
            "email": "carrier@carrier.com",
            "user_id": 54
        },
        {
            "display_name": "Jake Koppinger",
            "email": "jake@freightroll.com",
            "user_id": 285
        }
    ]
}
```
