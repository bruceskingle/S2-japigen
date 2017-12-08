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

package org.symphonyoss.s2.japigen.test.oneofeverything;

import java.io.IOException;

import org.junit.Assert;
import org.symphonyoss.s2.common.dom.DomSerializer;
import org.symphonyoss.s2.common.dom.DomWriter;
import org.symphonyoss.s2.common.dom.json.IImmutableJsonDomNode;
import org.symphonyoss.s2.common.dom.json.IJsonDomNode;
import org.symphonyoss.s2.common.dom.json.IJsonObject;
import org.symphonyoss.s2.common.dom.json.ImmutableJsonObject;
import org.symphonyoss.s2.common.dom.json.MutableJsonObject;
import org.symphonyoss.s2.common.dom.json.jackson.JacksonAdaptor;
import org.symphonyoss.s2.common.exception.BadFormatException;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableSet;
import com.google.protobuf.ByteString;
import com.symphony.s2.japigen.test.oneofeverything.facade.DoubleMinMax;
import com.symphony.s2.japigen.test.oneofeverything.facade.ObjectWithOneOfEverything;

public class TestOneOfEverything
{
  private void test(String expected, String received)
  {
    if(!expected.equals(received))
    {
      System.out.format("expected %s%nreceived %s%n", expected, received);
      System.out.flush();
      
      Assert.assertEquals(expected, received);
    }
  }
  
  public static void main(String[] argv) throws IOException, BadFormatException
  {
    ObjectWithOneOfEverything obj = ObjectWithOneOfEverything.newBuilder()
    .withABoolean(true)
    .withADouble(7.0)
    .withADoubleMinMax(new DoubleMinMax(5.0))
    .withSecs(10L)
    .withAListOfByteString(ImmutableList.of(ByteString.copyFrom("Hello".getBytes()), ByteString.copyFrom("World".getBytes())))
    .build();
    
    System.out.println("Created " + obj);
    
    DomWriter writer = new DomWriter(System.out);
    
    writer.write(obj.getJsonObject());
    
    obj = ObjectWithOneOfEverything.newBuilder()
    .withABoolean(false)
    .withADouble(27.0)
    .withADoubleMinMax(5.0)
    .withSecs(20L)
    .withAByteString(ByteString.copyFrom("Hello World".getBytes()))
    .withAFloat(3.14f)
    .withAListOfByteString(ImmutableList.of(ByteString.copyFrom("Hello".getBytes()), ByteString.copyFrom("World".getBytes())))
    .withASetOfByteString(ImmutableSet.of(ByteString.copyFrom("This is a set".getBytes()), ByteString.copyFrom("So the items are unique".getBytes())))
    .withNanos(200)
    .withAListOfByteString(ImmutableList.of(ByteString.copyFrom("More".getBytes()), ByteString.copyFrom("Strings".getBytes())))
    .build();
    
    writer.write(obj.getJsonObject());
    
    writer.flush();
    
    DomSerializer serializer = DomSerializer.newBuilder()
        .withCanonicalMode(true)
        .build();
    
    String json = serializer.serialize(obj.getJsonObject());
    
    System.out.println("Canonical JSON:");
    System.out.println(json);
    
    ObjectMapper mapper = new ObjectMapper();
    
    JsonNode tree = mapper.readTree(json.getBytes());
    
    System.out.println("Jackson DOM:");
    System.out.println(tree);
    
    IJsonDomNode adapted = JacksonAdaptor.adapt(tree);
    
    System.out.println("Adapted node:");
    writer.write(adapted);
    writer.flush();
    
    if(adapted instanceof IJsonObject)
    {
      //((MutableJsonObject)adapted).addIfNotNull("_type", "foo");
      try
      {
        ObjectWithOneOfEverything obj2 = new ObjectWithOneOfEverything((ImmutableJsonObject) adapted.immutify());
        
        System.out.println("Reconstructed object:");
        writer.write(obj2.getJsonObject());
      }
      catch(BadFormatException e)
      {
        System.err.println("Failed to deserialize from JSON");
        e.printStackTrace();
      }
    }
    else
    {
      System.err.println("Expected an object but received a " + adapted.getClass().getName());
    }
    writer.close();
    
    System.out.println("Test Complete");
  }
}
