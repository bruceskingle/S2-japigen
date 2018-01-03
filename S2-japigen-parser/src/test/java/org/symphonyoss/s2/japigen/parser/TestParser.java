/*
 *
 *
 * Copyright 2017 Symphony Communication Services, LLC.
 *
 * Licensed to The Symphony Software Foundation (SSF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The SSF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.symphonyoss.s2.japigen.parser;

import org.junit.Test;
import org.symphonyoss.s2.japigen.Japigen;
import org.symphonyoss.s2.japigen.model.Model;
import org.symphonyoss.s2.japigen.parser.error.UnknownFormatWarning;

public class TestParser extends AbstractParserTest
{
  @Test(expected=ParsingException.class)
  public void testNoInput() throws ParsingException
  {
    test(false, "");
  }
  
  @Test(expected=SchemaValidationException.class)
  public void testIncomplete() throws ParsingException
  {
    test(false, "{\n" + 
        "  \"openapi\": \"3.0.0\",\n" + 
        "  \"info\": {\n" + 
        "    \"version\": \"0.0.1\",\n" + 
        "    \"title\": \"Japigen Template Type Check\",\n" + 
        "    \"license\": {\n" + 
        "      \"name\": \"Apache2\"\n" + 
        "    }\n" + 
        "  }\n" + 
        "}");
  }
  
  @Test
  public void testInvalid() throws ParsingException
  {
    Model model = test(false, "{\n" + 
        "  \"openapi\": \"3.0.0\",\n" + 
        "  \"info\": {\n" + 
        "    \"version\": \"0.0.1\",\n" + 
        "    \"title\": \"Japigen Template Type Check\",\n" + 
        "    \"license\": {\n" + 
        "      \"name\": \"Apache2\"\n" + 
        "    }\n" + 
        "  },\n" + 
        "  \"paths\": {},\n" + 
        "  \"components\": {}\n" + 
        "  }\n" + 
        "}");
    
    assertHasOneErrorMissing(model, Japigen.X_ID);
  }

  @Test
  public void testMinimal() throws ParsingException
  {
    test(true, "{\n" + 
        "  \"openapi\": \"3.0.0\",\n" + 
        "  \"info\": {\n" + 
        "    \"version\": \"0.0.1\",\n" + 
        "    \"title\": \"Japigen Template Type Check\",\n" + 
        "    \"license\": {\n" + 
        "      \"name\": \"Apache2\"\n" + 
        "    }\n" + 
        "  },\n" + 
        "  \"x-japigen-id\": \"https://github.com/bruceskingle/S2-japigen/blob/master/S2-japigen-test/src/main/resources/test/typeCheck.json\",\n" + 
        "  \"x-japigen-model\": {\n" + 
        "    \"javaGenPackage\":  \"com.symphony.s2.japigen.test.typeCheck\",\n" + 
        "    \"javaFacadePackage\":  \"com.symphony.s2.japigen.test.typeCheck.facade\"\n" + 
        "  },\n" + 
        "  \"paths\": {},\n" + 
        "  \"components\": {}\n" + 
        "  }\n" + 
        "}");
  }

  @Test
  public void testBadByteFormat() throws ParsingException
  {
    Model model = test(true, "{\n" + 
        "  \"openapi\": \"3.0.0\",\n" + 
        "  \"info\": {\n" + 
        "    \"version\": \"0.0.1\",\n" + 
        "    \"title\": \"Symphony 2.0 Typedefs\",\n" + 
        "    \"license\": {\n" + 
        "      \"name\": \"Apache2\"\n" + 
        "    }\n" + 
        "  },\n" + 
        "  \"x-japigen-id\": \"https://github.com/bruceskingle/S2-japigen/blob/master/S2-japigen-test/src/main/resources/test/typeCheck.json\",\n" + 
        "  \"x-japigen-model\": {\n" + 
        "    \"javaGenPackage\":  \"com.symphony.s2.common.types.japigen\",\n" + 
        "    \"javaFacadePackage\":  \"com.symphony.s2.common.types.japigen.facade\"\n" + 
        "  },\n" + 
        "  \"paths\": {},\n" + 
        "  \"components\": {\n" + 
        "    \"schemas\": {\n" + 
        "      \"Hash\": {\n" + 
        "        \"description\": \"A Hash value, encoded as Base64.\",\n" + 
        "        \"type\": \"string\",\n" + 
        "        \"format\": \"bytes\"\n" + 
        "      }\n" + 
        "    }\n" + 
        "  }\n" + 
        "}");
    
    assertHasOneWarning(model, UnknownFormatWarning.class);
  }
}
