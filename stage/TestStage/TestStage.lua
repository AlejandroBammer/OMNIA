return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.11.0",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 480,
  height = 270,
  tilewidth = 1,
  tileheight = 1,
  nextlayerid = 7,
  nextobjectid = 23,
  properties = {},
  tilesets = {
    {
      name = "sprites",
      firstgid = 1,
      filename = "sprites.tsx",
      exportfilename = "sprites.lua"
    }
  },
  layers = {
    {
      type = "objectgroup",
      draworder = "index",
      id = 3,
      name = "sprites",
      class = "Sprite",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 11,
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 272,
          width = 484,
          height = 95,
          rotation = 0,
          gid = 8,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "Weabo",
          type = "",
          shape = "rectangle",
          x = 59,
          y = 200,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 5,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "Spoilerman",
          type = "",
          shape = "rectangle",
          x = 218,
          y = 200,
          width = 29,
          height = 61,
          rotation = 0,
          gid = 6,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "Mariku",
          type = "",
          shape = "rectangle",
          x = 355,
          y = 204,
          width = 32,
          height = 67,
          rotation = 0,
          gid = 7,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "index",
      id = 5,
      name = "game objects",
      class = "GameObject",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 19,
          name = "UnObjeto",
          type = "Palayer",
          shape = "rectangle",
          x = 150,
          y = 200,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["inputRespond"] = true
          }
        },
        {
          id = 22,
          name = "OtroObjeto",
          type = "Palayer",
          shape = "rectangle",
          x = 300,
          y = 200,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["inputRespond"] = false
          }
        }
      }
    },
    {
      type = "objectgroup",
      draworder = "index",
      id = 6,
      name = "collisions",
      class = "Collision",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 20,
          name = "",
          type = "",
          shape = "rectangle",
          x = 1,
          y = 200,
          width = 480,
          height = 65,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
