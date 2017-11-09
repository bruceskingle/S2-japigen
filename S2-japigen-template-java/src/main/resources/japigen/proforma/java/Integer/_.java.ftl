/**
 * GENERATED CODE - DO NOT EDIT OR CHECK IN TO SOURCE CODE CONTROL
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
 *
 * Generated from
 *		Template groupId		 org.symphonyoss.s2.japigen
 *           artifactId S2-japigen-template-java
 *		Template dir			   Integer
 *		Template file		   _.java.ftl
 *		Template version	   1.0
 */

package ${javaFacadePackage};

import ${javaGenPackage}.${model.camelCapitalizedName}ModelObject;

<#switch model.format>
 <#case "int32">
  <#assign javaType="Integer">
  <#break>
  
 <#default>
  <#assign javaType="Long">
</#switch>  


<#if model.description??>
/*
  ${model.description}
*/
</#if>
@SuppressWarnings("unused")
public class ${model.camelCapitalizedName} extends ${model.camelCapitalizedName}ModelObject
{
	private ${javaType} value_;
	
	public ${model.camelCapitalizedName}(${javaType} value)
  {
    super(value);
  }
}
