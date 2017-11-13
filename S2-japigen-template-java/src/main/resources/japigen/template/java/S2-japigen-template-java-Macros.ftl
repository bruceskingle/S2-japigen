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
  <#assign javaTypeAssignPrefix="">
  <#assign javaTypeAssignPostfix="">
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
      <#assign javaTypeAssignPostfix=")">
      <#switch model.cardinality>
        <#case "SET">
          <#assign javaType="Set<${javaType}>">
          <#assign javaCardinality="Set">
          <#assign javaTypeAssignPrefix="Collections.unmodifiableSet(">
          <#break>
          
        <#default>
          <#assign javaType="List<${javaType}>">
          <#assign javaCardinality="List">
          <#assign javaTypeAssignPrefix="Collections.unmodifiableList(">
      </#switch>
      <#break>
    
    <#case "Object">
      <#assign javaType="NO JAVA TYPE FOR OBJECT">
      <#break>
      
    <#default>
      // UNKNOWN ELEMENT TYPE ${model.elementType} for model ${model}
      <#assign javaType="UNKNOWN">
  </#switch>
</#macro>

<#macro checkLimits2 model name>
  <#if model.minimum??>
    if(${name} != null && ${name} < ${model.minimumAsString})
      throw new IllegalArgumentException("Value " + ${name} + " is less than the minimum allowed of ${model.minimum}");
  </#if>
  <#if model.maximum??>

    if(${name} != null && ${name} > ${model.maximumAsString})
      throw new IllegalArgumentException("Value " + ${name} + " is more than the maximum allowed of ${model.maximum}");
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
    <#break>
  </#switch>
</#macro>

<#macro importFieldTypes model>
<#if model.hasCollections>
import java.util.Collections;
</#if>
<#if model.hasList>
import java.util.List;
</#if>
<#if model.hasSet>
import java.util.Set;
</#if>
<#if model.hasByteString>
import com.google.protobuf.ByteString;
</#if>

<#list model.referencedTypes as field>
import ${field.model.modelMap["javaFacadePackage"]}.${field.camelCapitalizedName};
</#list>
</#macro>

<@setJavaType model/>
