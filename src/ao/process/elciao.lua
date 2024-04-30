local ao = require('ao')
local json = require('json')

--[[
     Initialize State

     ao.id is equal to the Process.Id
   ]]
--

if not RpcEndpoint then RpcEndpoint = '' end

if not Network then Network = '' end

if not ChainId then ChainId = '' end 

if not Name then Name = 'elciao instance' end

if not Admin then Admin = '' end

if not LatestBlock then LatestBlock = '' end

if not LatestSlot then LatestSlot = '' end

if not Blocks then Blocks = {} end

if not NodeCreated then NodeCreated = false end

--[[
     Add handlers for each incoming Action defined by the ao Standard Token Specification
   ]]
--

--[[
     Info
   ]]
--

Handlers.add('info', Handlers.utils.hasMatchingTag('Action', 'Info'), function(msg)
  ao.send({
    Target = msg.From,
    RpcEndpoint = RpcEndpoint,
    Network = Network,
    ChainId = ChainId,
    Name = Name,
    Admin = Admin,
    LatestBlock = LatestBlock,
  })
end)

Handlers.add('getBlocks', Handlers.utils.hasMatchingTag('Action', 'GetBlocks'), function(msg)
  ao.send({
    Target = msg.From,
    Data = json.encode(Blocks)
  })
end)
--[[
     Balance
   ]]
--


--[[
    Mint
   ]]
--

Handlers.add('setUpNode', Handlers.utils.hasMatchingTag('Action', 'SetUpNode'), function(msg)
  assert( NodeCreated == false, 'Node already created')
  assert(type(msg.Slot) == 'string', 'Address required!')
  assert(type(msg.BlockNumber) == 'string', 'Address required!')
  assert(type(msg.Data) == 'string', 'MemId is Required!')
  assert(type(msg.Admin) == 'string', 'a')
  assert(type(msg.RpcEndpoint) == 'string', 'a')
    assert(type(msg.Network) == 'string', 'a')

      assert(type(msg.ChainId) == 'string', 'a')
        assert(type(msg.Name) == 'string', 'a')
            assert(type(msg.Admin) == 'string', 'a')

      NodeCreated = true

      RpcEndpoint = msg.RpcEndpoint
      Network = msg.Network
      ChainId = msg.ChainId
      Name = msg.Name
      Admin = msg.Admin
      LatestBlock = msg.BlockNumber
      LatestSlot = msg.Slot



    Blocks[msg.BlockNumber] = msg.Data

    ao.send({
      Action = 'Elciao-Setup-Notice',
      BlockNumber = msg.BlockNumber,
      Slot = msg.Slot
    })
end)


Handlers.add('indexBlock', Handlers.utils.hasMatchingTag('Action', 'IndexBlock'), function(msg)
  assert(type(msg.RpcEndpoint) == 'string', 'Quantity is required!')
  assert(type(msg.Network) == 'string', 'Address required!')
  assert(type(msg.Data) == 'string', 'MemId is Required!')
  assert(msg.From == Admin, 'invalid caller')
  assert(tonumber(msg.BlockNumber) > LatestBlock, '')
  assert(tonumber(msg.Slot) > LatestSlot, '')
  Blocks[msg.BlockNumber] = msg.Data

    ao.send({
      Action = 'Elciao-Notice',
      BlockNumber = msg.BlockNumber,
      Slot = msg.Slot
    })
end)
