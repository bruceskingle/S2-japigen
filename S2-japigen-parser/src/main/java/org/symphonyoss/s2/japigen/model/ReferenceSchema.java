/*
 *
 *
 * Copyright 2017 Symphony Communication Services, LLC.
 *
 * Licensed to The Symphony Software Foundation (SSF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
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

import org.symphonyoss.s2.japigen.parser.ParserContext;

/**
 * A schema defined as
 * 
 * <code>
  {
    "$ref": "#/some/URI"
  }
 * </code>
 * 
 * In order to allow forward references these objects need to be first created and then
 * resolved in a second pass of the model.
 * 
 * @author Bruce Skingle
 *
 */
public class ReferenceSchema extends ObjectOrReferenceSchema
{
  private final String  uri_;
  private ObjectSchema  reference_;
  
  public ReferenceSchema(Model model, ParserContext context, ParserContext node)
  {
    super(model, context, "Ref");
    uri_ = node.getJsonNode().asText();
  }

  public boolean  isResolved()
  {
    return reference_ != null;
  }

  public String getUri()
  {
    return uri_;
  }

  public ObjectSchema getReference()
  {
    return reference_;
  }
  
  @Override
  public String toString()
  {
    return super.toString(new ValueMap<String, Object>()
        .append("uri", uri_, null));
  }
}
