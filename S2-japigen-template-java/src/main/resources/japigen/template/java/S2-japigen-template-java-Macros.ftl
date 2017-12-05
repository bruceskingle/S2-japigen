<#macro setJavaType2 model>
  <#switch model.elementType>
    <#case "Integer">
      <#assign jsonNodeType="Integer">
      <#switch model.format>
        <#case "int32">
          <#assign javaType="Integer">
          <#break>
          
         <#default>
          <#assign javaType="Long">
      </#switch>
      <#break>
      
    <#case "Double">
      <#switch model.format>
        <#case "float">
          <#assign javaType="Float">
          <#break>
        
        <#default>
          <#assign javaType="Double">
      </#switch>
      <#break>
    
    <#case "String">
      <#switch model.format>
        <#case "byte">
          <#assign javaType="ByteString">
          <#break>
        
        <#default>
          <#assign javaType="String">
      </#switch>
      <#break>
    
    <#case "Boolean">
      <#assign javaType="Boolean">
      <#break>
      
    <#default>
      <#assign javaType="UNKNOWN_TYPE ${model.elementType} FORMAT ${model.format}">
  </#switch>
  <@setJavaType3 model/>
  <#assign javaRefType=javaType>
</#macro>

<#macro setJavaType3 model>
  <#assign javaBaseType=javaType>
  <#if model.attributes['javaExternalType']??>
    <#assign javaType=model.attributes['javaExternalType']>
    <#assign javaFacadeFullyQualifiedName="${model.attributes['javaExternalPackage']}.${javaType}">
  </#if>
</#macro>

<#macro setJavaType model>
  <#assign javaFacadeFullyQualifiedName="${javaFacadePackage}.${model.camelCapitalizedName}">
  <#assign javaType="">
  <#assign javaRefType="">
  <#assign javaTypeCopyPrefix="">
  <#assign javaTypeCopyPostfix="">
  <#assign javaBuilderTypeCopyPrefix=" = ">
  <#assign javaBuilderTypeCopyPostfix="">
  <#assign javaGetValuePrefix="">
  <#assign javaGetValuePostfix="">
  <#assign javaConstructTypePrefix="">
  <#assign javaConstructTypePostfix="">
  <#assign javaBuilderTypeNew="">
  <#assign addJsonNode="addIfNotNull">
  <#assign isNotNullable=false>
  <#assign javaCardinality="">
  <#switch model.elementType>
    <#case "Integer">
    <#case "Double">
    <#case "String">
    <#case "Boolean">
      <@setJavaType2 model/>
      <#break>
      
    <#case "Field">
      <@setJavaType2 model.type/>
      <#if model.required>
        <#assign isNotNullable=true>
      </#if>
      <#break>
      
    <#case "Ref">
      <@setJavaType2 model.type/>
      
      <#assign javaType=model.type.camelCapitalizedName>
      <#assign javaConstructTypePrefix="new ${javaType}(">
      <#assign javaConstructTypePostfix=")">
      <@setJavaType3 model.type/>
      <#assign javaGetValuePostfix=".getValue()">
      <#break>
    
    <#case "Array">
      <@setJavaType2 model.items/>
      <#assign addJsonNode="addCollectionOf${javaType}">
      <#assign javaTypeCopyPostfix=")">
      <#assign javaBuilderTypeCopyPostfix=")">
      <#assign javaElementType=javaType>
      <#switch model.cardinality>
        <#case "SET">
          <#assign javaType="Set<${javaType}>">
          <#assign javaCardinality="Set">
          <#assign javaTypeCopyPrefix="ImmutableSet.copyOf(">
          <#assign javaBuilderTypeCopyPrefix=".addAll(">
          <#assign javaBuilderTypeNew=" = new HashSet<>()">
          <#break>
          
        <#default>
          <#assign javaType="List<${javaType}>">
          <#assign javaCardinality="List">
          <#assign javaTypeCopyPrefix="ImmutableList.copyOf(">
          <#assign javaBuilderTypeCopyPrefix=".addAll(">
          <#assign javaBuilderTypeNew=" = new LinkedList<>()">
      </#switch>
      <#break>
    
    <#case "Object">
      <#assign javaType="NO JAVA TYPE FOR OBJECT">
      <#break>
    
    <#case "AllOf">
      <#assign javaType="NO JAVA TYPE FOR AllOf">
      <#break>
    
    <#case "OneOf">
      <#assign javaType=model.camelCapitalizedName>
      <#break>
      
    <#default>
      // UNKNOWN ELEMENT TYPE ${model.elementType} for model ${model}
      <#assign javaType="UNKNOWN">
  </#switch>
</#macro>

<#macro checkLimitsClassThrows model>
  <#list model.children as field>
    <#if isCheckLimitsThrows(field)>
 throws BadFormatException
      <#return>
    </#if>
  </#list>
</#macro>

<#macro checkLimitsAllOfThrows model>
  <#list model.fields as field>
    <#if isCheckLimitsThrows(field)>
 throws BadFormatException
      <#return>
    </#if>
  </#list>
</#macro>

<#macro checkLimitsThrows model>
  <#if isCheckLimitsThrows(model)>
 throws BadFormatException
  </#if>
</#macro>

<#function isCheckLimitsThrows model>
  <#switch model.elementType>
    <#case "Field">
        <#if model.type.minimum?? ||  model.type.maximum?? || model.required>
          <#return true>
        </#if>
      <#break>
      
    <#case "Ref">
        <#return isCheckLimitsThrows(model.type)/>
      <#break>
      
  <#default>
        <#if model.minimum?? ||  model.maximum??>
          <#return true>
        </#if>
  </#switch>
  <#return false>
</#function>

<#macro checkLimits2 model name>
  <#if model.minimum??>
    if(${name} != null && ${name} < ${model.minimumAsString})
      throw new BadFormatException("Value " + ${name} + " of ${name} is less than the minimum allowed of ${model.minimum}");
  </#if>
  <#if model.maximum??>

    if(${name} != null && ${name} > ${model.maximumAsString})
      throw new BadFormatException("Value " + ${name} + " of ${name} is more than the maximum allowed of ${model.maximum}");
  </#if>
</#macro>

<#macro checkLimits model name>
  <#switch model.elementType>
    <#case "Integer">
    <#case "Double">
    <#case "String">
      <@checkLimits2 model name/>
      <#break>
      
    <#case "Field">
      <@checkLimits2 model.type name/>
      <#if model.required>
      if(${name} == null)
        throw new BadFormatException("${name} is required.");
  
      </#if>
      <#break>
  </#switch>
</#macro>

<#function isCheckItemLimits model>
  <#switch model.elementType>
    <#case "Array">
      <#if model.minItems??>
        <#return true>
      </#if>
      <#if model.maxItems??>
        <#return true>
      </#if>
      <#break>
  </#switch>
  <#return false>
</#function>

<#macro checkItemLimitsThrows model>
  <#if isCheckItemLimits(model)>
 throws BadFormatException
  </#if>
</#macro>

<#macro checkItemLimits model name var>
  <#switch model.elementType>
    <#case "Array">
      <#if model.minItems??>
        if(${var}.size() < ${model.minItems})
        {
          throw new BadFormatException("${name} has " + ${var}.size() + " items but at least ${model.minItems} are required");
        }
      </#if>
      <#if model.maxItems??>
        if(${var}.size() > ${model.maxItems})
        {
          throw new BadFormatException("${name} has " + ${var}.size() + " items but at most ${model.maxItems} are allowed");
        }
      </#if>
      <#break>
  </#switch>
</#macro>

<#macro importFieldTypes model includeImpls>
<#if model.hasCollections>
</#if>
<#if model.hasList || model.hasSet>
import java.util.Iterator;
</#if>
<#if model.hasList>
import java.util.List;
  <#if includeImpls>
import java.util.LinkedList;
import com.google.common.collect.ImmutableList;
  </#if>
</#if>
<#if model.hasSet>
import java.util.Set;
  <#if includeImpls>
import java.util.HashSet;
import com.google.common.collect.ImmutableSet;
  </#if>
</#if>
<#if model.hasByteString>
import com.google.protobuf.ByteString;
</#if>

<#list model.referencedTypes as field>
  <#switch field.elementType>
    <#case "OneOf">
import ${field.model.modelMap["javaFacadePackage"]}.${model.camelCapitalizedName}.${field.camelCapitalizedName};
    <#break>

    <#default>
<@setJavaType field/>
import ${javaFacadeFullyQualifiedName};
  </#switch>  
</#list>
</#macro>

<@setJavaType model/>
