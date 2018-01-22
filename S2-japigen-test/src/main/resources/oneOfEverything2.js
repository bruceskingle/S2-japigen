{
  // This is a comment.
  "openapi": "3.0.0",
  "info": {
    "version": "0.0.1",
    "title": "Japigen Test Types",
    "license": {
      "name": "Apache2"
    }
  },
  "x-japigen-id": "https://github.com/bruceskingle/S2-japigen/blob/master/S2-japigen-test/src/main/resources/test/oneOfEverything.json",
  "x-japigen-model": {
    "javaGenPackage":  "com.symphony.s2.japigen.test.oneofeverything",
    "javaFacadePackage":  "com.symphony.s2.japigen.test.oneofeverything.facade"
  },
  "paths": {
    "/hello/{greeting}": {
	    "summary": "Greeting operations.",
	    /*
	     * this is another comment.
	    */
	    "description": "Various operations to do with greeting callers.\
	    This is a very long comment\
      Split over several lines.",
      "get": {
        "summary": "Say Hello",
        "operationId": "sayHello",
        "tags": [
          "hello"
        ],
        "parameters": [
          {
            "name": "greeting",
            "in": "path",
            "description": "A greeting from the client",
            "required": true,
            "schema": {
              "$ref": "#/components/schemas/DefString"
            }
          },
          {
            "name": "limit",
            "in": "query",
            "description": "How many items to return at one time (max 100)",
            "required": false,
            "schema": {
              "type": "integer",
              "format": "int32"
            }
          },
          {
            "name": "sessionToken",
            "in": "cookie",
            "description": "A cookie parameter",
            "required": false,
            "schema": {
              "type": "string"
            }
          },
          {
            "name": "anotherSessionToken",
            "in": "cookie",
            "description": "Another cookie parameter",
            "required": false,
            "schema": {
              "$ref": "#/components/schemas/Int64MinMax"
            }
          },
          {
            "name": "authToken",
            "in": "header",
            "description": "A header parameter",
            "required": false,
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "An paged array of objects",
            "headers": {
              "x-next": {
                "description": "A link to the next page of responses",
                "schema": {
                  "type": "string"
                }
              }
            },
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/DefString"
                }
              }
            }
          },
          "default": {
            "description": "unexpected error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/DefString"
                }
              }
            }
          }
        }
      }
    },
    "/hello/world/{greeting}": {
      "get": {
        "summary": "Say Hello",
        "operationId": "sayHello",
        "tags": [
          "hello"
        ],
        "parameters": [
          {
            "name": "greeting",
            "in": "path",
            "description": "A greeting from the client",
            "required": true,
            "schema": {
              "$ref": "#/components/schemas/DefString"
            }
          },
          {
            "name": "limit",
            "in": "query",
            "description": "How many items to return at one time (max 100)",
            "required": false,
            "schema": {
              "type": "integer",
              "format": "int32"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "An paged array of objects",
            "headers": {
              "x-next": {
                "description": "A link to the next page of responses",
                "schema": {
                  "type": "string"
                }
              }
            },
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/DefString"
                }
              }
            }
          },
          "default": {
            "description": "unexpected error",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/DefString"
                }
              }
            }
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "DefInt": {
        "description": "A default integer.",
        "type": "integer"
      },
      "Int64": {
        "description": "A 64 bit integer.",
        "type": "integer",
        "format": "int64"
      },
      "Int64Min": {
        "description": "A 64 bit integer with a minimum.",
        "type": "integer",
        "format": "int64",
        "minimum": -123
      },
      "Int64Max": {
        "description": "A 64 bit integer with a maximum.",
        "type": "integer",
        "format": "int64",
        "maximum": 80000
      },
      "Int64MinMax": {
        "description": "A 64 bit integer with a minimum and maximum.",
        "type": "integer",
        "format": "int64",
        "minimum": -123,
        "maximum": 80000
      },
      
      "Int32": {
        "description": "A 32 bit integer.",
        "type": "integer",
        "format": "int32"
      },
      "Int32Min": {
        "description": "A 32 bit integer with a minimum.",
        "type": "integer",
        "format": "int32",
        "minimum": -123
      },
      "Int32Max": {
        "description": "A 32 bit integer with a maximum.",
        "type": "integer",
        "format": "int32",
        "maximum": 80000
      },
      "Int32MinMax": {
        "description": "A 32 bit integer with a minimum and maximum.",
        "type": "integer",
        "format": "int32",
        "minimum": -123,
        "maximum": 80000
      },
      
      "DefDouble": {
        "description": "A default double.",
        "type": "number"
      },
      "DoubleNoLimits": {
        "description": "A Double.",
        "type": "number",
        "format": "double"
      },
      "DoubleMin": {
        "description": "A Double with a minimum.",
        "type": "number",
        "format": "double",
        "minimum": -123.25
      },
      "DoubleMax": {
        "description": "A Double with a maximum.",
        "type": "number",
        "format": "double",
        "maximum": 80000.25
      },
      "DoubleMinMax": {
        "description": "A Double with a minimum and maximum.",
        "type": "number",
        "format": "double",
        "minimum": -123.25,
        "maximum": 80000.25
      },
      
      "DefFloat": {
        "description": "A Float.",
        "type": "number",
        "format": "float"
      },
      "FloatMin": {
        "description": "A Float with a minimum.",
        "type": "number",
        "format": "float",
        "minimum": -123.25
      },
      "FloatMax": {
        "description": "A Float with a maximum.",
        "type": "number",
        "format": "float",
        "maximum": 80000.25
      },
      "FloatMinMax": {
        "description": "A Float with a minimum and maximum.",
        "type": "number",
        "format": "float",
        "minimum": -123.25,
        "maximum": 80000.25
      },
      
      "DefString": {
        "description": "A default String.",
        "type": "string"
      },
      "StringOfBytes": {
        "description": "A byte String.",
        "type": "string",
        "format": "byte"
      },
      "ListOfByteString": {
        "description": "A list of byte String.",
        "type": "array",
        "x-japigen-cardinality": "LIST",
        "minItems": 1,
        "maxItems": 5,
        "items": {
          "description": "A byte String list element.",
          "type": "string",
          "format": "byte"
        }
      },
      
      "SetOfFloatMinMax": {
        "description": "A set of byte String.",
        "type": "array",
        "x-japigen-cardinality": "SET",
        "items": {
          "$ref": "#/components/schemas/FloatMinMax"
        }
      },
      
      "ASimpleObject": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "value": {
            "type": "string"
          }
        }
      },
      
      "ObjectWithOneOfEverything": {
        "description": "An object with one field of every type.\
        This is a long comment",
        "type": "object",
        "required": [
          "secs", "aDoubleMinMax"
        ],
        "properties": {
          "aBoolean": {
            "description": "A boolean.",
            "type": "boolean"
          },
          "aByteString": {
            "description": "A byte String.",
            "type": "string",
            "format": "byte"
          },
          "secs": {
            "description": "Seconds measured from the standard Java epoch of 1970-01-01T00:00:00Z where instants after the epoch have positive values, and earlier instants have negative values.",
            "type": "integer",
            "format": "int64"
          },
          "aFloat": {
            "description": "A float",
            "type": "number",
            "format": "float",
            "minimum": -77723.00025,
            "maximum": 7650000.00025
          },
          "aDouble": {
            "description": "A float",
            "type": "number",
            "format": "double",
            "minimum": -765546546547723.03330025,
            "maximum": 7665465456464550000.00333025
          },
          "aDoubleMinMax": {
            "$ref": "#/components/schemas/DoubleMinMax"
          },
          "aSetOfByteString": {
            "description": "A set of byte String.",
            "type": "array",
            "x-japigen-cardinality": "SET",
            "items": {
              "description": "A byte String array element.",
              "type": "string",
              "format": "byte"
            }
          },
          "aListOfByteString": {
            "description": "A list of byte String.",
            "type": "array",
            "minItems": 1,
            "maxItems": 5,
            "items": {
              "description": "A byte String array element.",
              "type": "string",
              "format": "byte"
            }
          },
          "nanos": {
            "description": "Nanosecond-of-second, which will always be between 0 and 999,999,999",
            "type": "integer",
            "format": "int32",
            "minimum": 0,
            "maximum": 999999999
          },
          "aHash": {
            "$ref": "#/components/schemas/Hash"
          }
        }
      },
      "Hash": {
        "description": "A Hash value, encoded as Base64, represented by an external class which we cant change so we need a factory generated.",
        "type": "string",
        "format": "byte",
        "x-japigen-attributes": {
          "javaExternalPackage":  "org.symphonyoss.s2.japigen.test.oneofeverything",
          "javaExternalType":     "TestHash"
        }
      },
      "DirectHash": {
        "description": "A Hash value, encoded as Base64, represented by an external class which has our expected factory methods.",
        "type": "string",
        "format": "byte",
        "x-japigen-attributes": {
          "javaExternalPackage":  "org.symphonyoss.s2.japigen.test.oneofeverything",
          "javaExternalType":     "DirectHash",
          "isDirectExternal":     "true"
        }
      },
      "anAllOf": {
        "allOf": [
          {
            "$ref": "#/components/schemas/DoubleMinMax"
          },
          {
            "$ref": "#/components/schemas/Int64MinMax"
          },
          {
            "$ref": "#/components/schemas/ASimpleObject"
          }
        ]
      },
      
      "OneOfExample": {
        "oneOf": [
          {
            "$ref": "#/components/schemas/ASimpleObject"
          },
          {
            "$ref": "#/components/schemas/ObjectWithOneOfEverything"
          }
        ],
        "discriminator": {
          "propertyName": "thisIsNotNeededAndShouldCauseAnError"
        }
      },
      
      "ListOfObjects": {
        "description": "A list of objects.",
        "type": "array",
        "x-japigen-cardinality": "LIST",
        "minItems": 1,
        "maxItems": 5,
        "items": {
          "$ref": "#/components/schemas/ASimpleObject"
        }
      },
      "Colour": {
        "description": "An enumeration.",
        "type": "string",
        "enum": [
          "black",
          "white",
          "red",
          "blue",
          "green"
        ]
      },
      "Texture": {
        "description": "An external enumeration.",
        "type": "string",
        "enum": [
          "rough",
          "smooth"
        ],
        "x-japigen-attributes": {
          "javaExternalPackage":  "org.symphonyoss.s2.japigen.test.oneofeverything",
          "javaExternalType":     "TestTexture"
         }
      },
      "AnEnumObject": {
        "type": "object",
        "properties": {
          "texture": {
            "$ref": "#/components/schemas/Texture"
          },
          "colour": {
            "$ref": "#/components/schemas/Colour"
          },
          "aHash": {
            "$ref": "#/components/schemas/Hash"
          },
          "aDirectHash": {
            "$ref": "#/components/schemas/DirectHash"
          }
        }
      }
    }
  }
}