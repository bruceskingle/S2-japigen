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

package org.symphonyoss.s2.japigen.model;

import org.symphonyoss.s2.japigen.JAPIGEN;
import org.symphonyoss.s2.japigen.parser.ParserContext;
import org.symphonyoss.s2.japigen.parser.error.ParserError;
import org.symphonyoss.s2.japigen.parser.error.ParserWarning;


public class Discriminator extends ModelElement
{

  private static final String UNNAMED = "Unnamed";

  public Discriminator(OneOfSchema parent, ParserContext context)
  {
    super(parent, context, "Discriminator", initName(context));
    
    if(getName() == UNNAMED)
      context.raise(new ParserError("A %s requires a %s", JAPIGEN.DISCRIMINATOR, JAPIGEN.PROPERTY_NAME));
    
    ParserContext map = context.get(JAPIGEN.MAPPING);
    
    if(map != null)
    {
      context.raise(new ParserWarning("Discriminator mapping is not supported"));
    }
  }

  private static String initName(ParserContext context)
  {
    ParserContext ctx = context.get(JAPIGEN.PROPERTY_NAME);
    
    if(ctx == null)
      return UNNAMED;
    
    return ctx.getJsonNode().asText();
  }

}
