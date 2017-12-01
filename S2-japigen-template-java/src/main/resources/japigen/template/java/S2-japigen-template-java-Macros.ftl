<#macro setJavaType2 elementType format>
  <#switch elementType>
    <#case "Integer">
      <#switch format>
        <#case "int32">
          <#assign javaType="Integer">
          <#break>
          
         <#default>
          <#assign javaType="Long">
      </#switch>
      <#break>
      
    <#case "Double">
      <#switch format>
        <#case "float">
          <#assign javaType="Float">
          <#break>
        
        <#default>
          <#assign javaType="Double">
      </#switch>
      <#break>
    
    <#case "String">
      <#switch format>
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
      <#assign javaType="UNKNOWN_TYPE ${elementType} FORMAT ${format}">
  </#switch>
</#macro>

<#macro setJavaType model>
  <#assign javaTypeCopyPrefix="">
  <#assign javaTypeCopyPostfix="">
  <#assign javaBuilderTypeCopyPrefix="= ">
  <#assign javaBuilderTypeCopyPostfix="">
  <#assign javaBuilderTypeNew="">
  <#switch model.elementType>
    <#case "Integer">
    <#case "Double">
    <#case "String">
    <#case "Boolean">
      <@setJavaType2 model.elementType model.format/>
      <#break>
      
    <#case "Field">
      <@setJavaType2 model.type.elementType model.type.format/>
      <#break>
      
    <#case "Ref">
      <#assign javaType=model.type.camelCapitalizedName>
      <#break>
    
    <#case "Array">
      <@setJavaType2 model.items.elementType model.items.format/>
      <#assign javaTypeCopyPostfix=")">
      <#assign javaBuilderTypeCopyPostfix=")">
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

<#macro checkLimits2 model name>
  <#if model.minimum??>
    if(${name} != null && ${name} < ${model.minimumAsString})
      throw new IllegalArgumentException("Value " + ${name} + " of ${name} is less than the minimum allowed of ${model.minimum}");
  </#if>
  <#if model.maximum??>

    if(${name} != null && ${name} > ${model.maximumAsString})
      throw new IllegalArgumentException("Value " + ${name} + " of ${name} is more than the maximum allowed of ${model.maximum}");
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
        throw new IllegalArgumentException("${name} is required.");

    </#if>
    <#break>
  </#switch>
</#macro>

<#macro importFieldTypes model includeImpls>
<#if model.hasCollections>
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
import ${field.model.modelMap["javaFacadePackage"]}.${field.camelCapitalizedName};

  </#switch>  
</#list>
</#macro>

<@setJavaType model/>
