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

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.symphonyoss.s2.common.exception.BadFormatException;

import com.symphony.s2.japigen.runtime.IModelObject;
import com.symphony.s2.japigen.test.oneofeverything.facade.Cat;
import com.symphony.s2.japigen.test.oneofeverything.facade.Dog;
import com.symphony.s2.japigen.test.oneofeverything.facade.Lizard;

public class TestPets extends AbstractModelObjectTest
{

  @Test
  public void testSerialize() throws BadFormatException
  {
    Dog fido = Dog.newBuilder()
        .withName("Fido")
        .withPackSize(10)
        .withPetType("Dog")
        .build();
    
    assertEquals("{\"_type\":\"https://github.com/bruceskingle/S2-japigen/blob/master/S2-japigen-test/src/main/resources/test/oneOfEverything.json#/components/schemas/Dog\",\"name\":\"Fido\",\"packSize\":10,\"petType\":\"Dog\"}", fido.serialize());
  }
  
  private List<IModelObject> createPets() throws BadFormatException
  {
    List<IModelObject> pets = new ArrayList<>();
    
    pets.add(Dog.newBuilder()
      .withName("Fido")
      .withPackSize(10)
      .build());
    
    pets.add(Dog.newBuilder()
        .withName("Spot")
        .withPackSize(10)
        .build());
    
    pets.add(Cat.newBuilder()
        .withName("Felix")
        .build());
    
    pets.add(Lizard.newBuilder()
        .withName("Louis")
        .withLovesRocks(true)
        .build());
    
    return pets;
  }
}
