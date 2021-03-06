require 'busted.runner'()

local astbuilder = require 'nelua.syntaxdefs'().astbuilder
local assert = require 'spec.tools.assert'
local Attr = require 'nelua.attr'
local n = astbuilder.aster

describe("Nelua AST should", function()

it("create a valid ASTNode", function()
  local node = n.Number{'dec', '10'}
  assert(node)
  assert.same(node.tag, 'Number')
  assert.same({node:args()}, {'dec', '10'})
end)


it("error on invalid ASTNode", function()
  assert.has_error(function() n.Invalid{} end)
  assert.has_error(function() n.Block{1} end)
  assert.has_error(function() n.Block{{1}} end)
  assert.has_error(function() n.Block{{'a'}} end,
    [[invalid shape while creating AST node "Block": field 1: array item 1: expected "aster.Node"]])
  assert.has_error(function() astbuilder:create('Invalid') end)
end)

it("clone different ASTNode", function()
  local node =
    n.Block{attr=Attr{someattr = true}, {
      n.Return{{
        n.Nil{attr=Attr{someattr = true}},
  }}}}
  local cloned = node:clone()
  assert(cloned.attr.someattr == nil)
  assert(#cloned.attr == 0)
  assert(cloned ~= node)
  assert(cloned[1] ~= node[1])
  assert(cloned[1][1] ~= node[1][1])
  assert.same(tostring(cloned), [[Block {
  {
    Return {
      {
        Nil {
        }
      }
    }
  }
}]])
end)

end)
