"use strict"
/*
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · Import frameworks, libraries and tools
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
var chai = require("chai")
var expect = require("chai").expect
var chaiHttp = require("chai-http")
var settings = require("../../settings")


// · loading tools
chai.use(chaiHttp)


// · remote endpoint
const api_url_request = "/ws/users/confirmation"


// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
describe(`GET:${ settings.api.url.root }${ api_url_request }`, function() {
    beforeEach(done => {    
        done()
    })

    it("responds with standard successful message", () => {
        chai
        .request(settings.api.url.root)
        .post(api_url_request)
        .send({"email":"dev@mitwerken.de", "confirmation_token":"2020"})
        .end(settings.standardSuccessful)
    })

    it("responds with successful", () => {
        chai
        .request(settings.api.url.root)
        .post(api_url_request)
        .send({"email":"dev@mitwerken.de", "confirmation_token":"2020"})
        .end((error, response) => {
            expect(response.body).to.have.property("successful")
        })
    })

    it("responds with error by invalid token", () => {
        chai
        .request(settings.api.url.root)
        .post(api_url_request)
        .send({"email":"dev@mitwerken.de", "confirmation_token":"A no valid token"})
        .end((error, response) => {
            expect(response.body).to.have.property("successful").to.equal(false)
            expect(response.body).to.have.property("error")
        })
    })

    it("responds with error by invalid email", () => {
        chai
        .request(settings.api.url.root)
        .post(api_url_request)
        .send({"email":"notFoundEmail@mitwerken.de", "confirmation_token":"2020"})
        .end((error, response) => {
            expect(response.body).to.have.property("successful").to.equal(false)
            expect(response.body).to.have.property("error")
        })
    })

})
