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

package org.symphonyoss.s2.japigen.test;

import java.io.CharArrayReader;
import java.io.CharArrayWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringReader;

import org.junit.Assert;
import org.junit.Test;
import org.symphonyoss.s2.common.dom.DomBatchSerializer;
import org.symphonyoss.s2.common.dom.DomSerializer;
import org.symphonyoss.s2.common.dom.DomWriter;
import org.symphonyoss.s2.common.dom.json.IJsonDomNode;
import org.symphonyoss.s2.common.dom.json.IJsonObject;
import org.symphonyoss.s2.common.dom.json.ImmutableJsonObject;
import org.symphonyoss.s2.common.dom.json.jackson.JacksonAdaptor;
import org.symphonyoss.s2.common.exception.BadFormatException;
import org.symphonyoss.s2.common.reader.LinePartialReader;
import org.symphonyoss.s2.common.reader.LinePartialReader.Factory;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableSet;
import com.google.protobuf.ByteString;
import com.symphony.s2.japigen.runtime.ModelObject;
import com.symphony.s2.japigen.test.oneofeverything.OneOfEverythingModelSchemas;
import com.symphony.s2.japigen.test.oneofeverything.facade.ASimpleObject;
import com.symphony.s2.japigen.test.oneofeverything.facade.DoubleMinMax;
import com.symphony.s2.japigen.test.oneofeverything.facade.ObjectWithOneOfEverything;
import com.symphony.s2.japigen.test.oneofeverything.facade.OneOfEverythingSchemas;

public class TestOneOfEverything extends AbstractModelObjectTest
{
  
  @Test
  public void testSubset() throws BadFormatException
  {
    ImmutableJsonObject dom = ObjectWithOneOfEverything.newBuilder()
        .withABoolean(true)
        .withADouble(7.0)
        .withADoubleMinMax(new DoubleMinMax(5.0))
        .withSecs(10L)
        .withAListOfByteString(ImmutableList.of(ByteString.copyFrom("Hello".getBytes()), ByteString.copyFrom("World".getBytes())))
        .build().getJsonObject();
    
    DomSerializer serializer = DomSerializer.newBuilder()
        .withCanonicalMode(true)
        .build();
    
    assertEquals("{\"_type\":\"https://github.com/bruceskingle/S2-japigen/blob/master/S2-japigen-test/src/main/resources/test/oneOfEverything.json#/components/schemas/ObjectWithOneOfEverything\",\"aBoolean\":true,\"aDouble\":7.0,\"aDoubleMinMax\":5.0,\"aListOfByteString\":[\"SGVsbG8\",\"V29ybGQ\"],\"aSetOfByteString\":[],\"secs\":10}", serializer.serialize(ObjectWithOneOfEverything.newBuilder()
    .withABoolean(true)
    .withADouble(7.0)
    .withADoubleMinMax(new DoubleMinMax(5.0))
    .withSecs(10L)
    .withAListOfByteString(ImmutableList.of(ByteString.copyFrom("Hello".getBytes()), ByteString.copyFrom("World".getBytes())))
    .build().getJsonObject()));
  }
  
  @Test
  public void testRoundTrip() throws IOException, BadFormatException
  {
    ObjectWithOneOfEverything obj;
    
    
    DomWriter writer = new DomWriter(System.out);
    

    
    obj = createTestObject1();
    
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
        
        assertEquals(obj, obj2);
      }
      catch(BadFormatException e)
      {
        System.err.println("Failed to deserialize from JSON");
        e.printStackTrace();
        writer.close();
        throw e;
      }
    }
    else
    {
      fail("Expected an object but received a " + adapted.getClass().getName());
    }
    writer.close();
    
    System.out.println("Test Complete");
  }

  @Test
  public void testOneSchemas() throws BadFormatException, IOException
  {
    ASimpleObject source = createTestObject3();
    String serial = source.serialize();
    OneOfEverythingSchemas schemas = new OneOfEverythingSchemas();
    Reader reader = new StringReader(serial);
    ModelObject deserialized = schemas.parse(reader);
    
    assertEquals(source, deserialized);
  }
  
  @Test
  public void testMultipleSchemas() throws BadFormatException, IOException
  {
    CharArrayWriter writer = new CharArrayWriter();
    
    ASimpleObject source1 = createTestObject3();
    writer.write(source1.serialize());
    writer.write('\n');
    
    ASimpleObject source2 = createTestObject2();
    writer.write(source2.serialize());
    writer.write('\n');
    
    ObjectWithOneOfEverything source3 = createTestObject1();
    writer.write(source3.serialize());
    writer.write('\n');
    
    OneOfEverythingSchemas schemas = new OneOfEverythingSchemas();
    
    try(Factory readerFactory = new LinePartialReader.Factory(new CharArrayReader(writer.toCharArray())))
    {
      assertEquals(source1, schemas.parse(readerFactory.getNextReader()));
      assertEquals(source2, schemas.parse(readerFactory.getNextReader()));
      assertEquals(source3, schemas.parse(readerFactory.getNextReader()));
      
      Assert.assertEquals(null, readerFactory.getNextReader());
    }
  }
  
  private ASimpleObject createTestObject3() throws BadFormatException
  {
    return ASimpleObject.newBuilder()
        .withName("Simple3")
        .withValue("Value Three\nhas\nthree lines.")
        .build();
  }

  private ASimpleObject createTestObject2() throws BadFormatException
  {
    return ASimpleObject.newBuilder()
        .withName("Simple2")
        .withValue("Value Two")
        .build();
  }

  private ObjectWithOneOfEverything createTestObject1() throws BadFormatException
  {
    return ObjectWithOneOfEverything.newBuilder()
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
  }
}
