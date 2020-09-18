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
var settings = require("../settings")


// · loading tools
chai.use(chaiHttp)


// · remote endpoint
const api_url_request = "/api/authorization/authenticate"


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
        .send({"email":"dev@lesli.cloud", "password":"lesli2020"})
        .end(settings.standardSuccessful)
    })

    it("responds with a JWT", () => {
        chai
        .request(settings.api.url.root)
        .post(api_url_request)
        .send({"email":"dev@lesli.cloud", "password":"lesli2020"})
        .end((error, response) => {
            expect(response.body.data).to.have.property("token")
        })
    })

    it("responds with error by invalid credentials", () => {
        chai
        .request(settings.api.url.root)
        .post(api_url_request)
        .send({"email":"dev@lesli.cloud", "password":"incorrect"})
        .end((error, response) => {
            expect(response.body).to.have.property("error")
        })
    })

})
