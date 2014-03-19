handler =
  meta:
    owner_email: "hello@designedbygold.com"
    publication_api_version: "1.0"
    name: "iDoneThis"
    description: "What did you do yesterday?"
    delivered_on: "every day"
    external_configuration: false
    send_timezone_info: true
    send_delivery_count: true

  #use default edition handler
  edition: `undefined`

  #use default sample handler
  sample: `undefined`

module.exports = handler
