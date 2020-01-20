
var chai = require('chai')
var chaiHttp = require('chai-http');
var expect = chai.expect;

chai.use(chaiHttp);

describe("Websites", function() {

    describe("GET:/websites", function() {

        it("it render landing page", function() {

            return chai.request('http://0.0.0.0:3000').get('/').then(response => {

                expect(response.status).to.equal(200)

            })

        })

    })

})
