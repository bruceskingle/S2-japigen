/*
 *
 *
 * Copyright 2018 Symphony Communication Services, LLC.
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

package com.symphony.s2.japigen.runtime;

import org.apache.commons.codec.binary.Base64;
import org.symphonyoss.s2.common.dom.json.JsonString;
import org.symphonyoss.s2.common.dom.json.JsonValue;
import org.symphonyoss.s2.common.exception.BadFormatException;

import com.google.protobuf.ByteString;

public abstract class ModelByteStringTypeBuilder<M> extends ModelTypeBuilder<M,ByteString>
{
  @Override
  public M build(JsonValue<?, ?> jsonValue) throws BadFormatException
  {
    if(jsonValue instanceof JsonString)
    {
      return build(
          ByteString.copyFrom(
              Base64.decodeBase64(
                  ((JsonString)jsonValue).asString()
              )
          )
      );
    }
    
    throw new BadFormatException("Expected a string but found a " + jsonValue.getClass().getName());
  }

}
