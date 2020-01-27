# "use strict";
# const expect = require("chai").expect;
# const utils = require("../utils");
#
# describe("utils", () => {
#   it("should exist", () => {
#     expect(utils).to.be.ok;
#   });
#
#   it("generateDepositAddress generates a string with 8 characters", () => {
#     const depositAddress = utils.generateDepositAddress();
#     expect(typeof depositAddress).to.equal("string");
#     expect(depositAddress).to.have.length(8);
#   });
# });

require 'test/unit'
require_relative '../utils'

class TestUtils < Test::Unit::TestCase
  def test_generate_deposit_address
    deposit_address = generate_deposit_address
    assert_kind_of(String, deposit_address)
    assert_equal(8, deposit_address.length)
  end
end
