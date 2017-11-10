/**
 * GENERATED CODE - DO NOT EDIT OR CHECK IN TO SOURCE CODE CONTROL
 *
 * Copyright ${year} Symphony Communication Services, LLC.
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
 *
 * Generated from
 *		Template groupId		 org.symphonyoss.s2.japigen
 *           artifactId S2-japigen-template-java
 *		Template dir			   String
 *		Template file		   _ModelType.java.ftl
 *		Template version	   1.0
 *  At                  ${date}
 */

package ${javaGenPackage};

<#include "String.ftl">
public class ${model.camelCapitalizedName}ModelType
{
  private String value_;
  
  public ${model.camelCapitalizedName}ModelType(String value)
  {
    value_ = value;
  }
  
  public String getValue()
  {
    return value_;
  }
}
