<#------------------------------------------------------------------------------------------------------
 # 
 # This is the master definition of what the variables defined in macros mean.
 # ===========================================================================
 #
 #
 # Defined by the model:
 # ---------------------
 # javaModel.name                  Name as defined in the openApi3 input spec
 #
 # javaModel.camelName             Name in camel case with a lower case first letter
 #
 # javaModel.camelCapitalizedName  Name in camel case with an upper case first letter
 #
 # javaModel.snakeName             Name in snake case with a lower case first letter
 #
 # javaModel.snakeCapitalizedName  Name in snake case with an upper case first letter 
 #
 # javaModel.elementType           The type of the parse tree element
 #
 #
 #
 # Defined by setJavaType macro:
 # -----------------------------
 # javaClassName                   Name of the Java class to be referred to from other code
 #
 # javaFullyQualifiedClassName     Fully qualified name of the Java class to be referred to from other
 #                                 code, e.g. for imports
 #
 # javaFieldClassName              Name of Java class for the field inside a generated class
 #  
 # javaElementClassName            Name of Java class for the the elements of a collection. For
 #                                 non-collection types this is the same as javaFieldClassName
 #  
 # isNotNullable                   Boolean is true for required fields in an object, otherwise false
 #  
 # isArrayType                     Boolean is true for array fields, otherwise false
 #  
 # isGenerated                     Boolean is true for fields which require range checks otherwise false
 #  
 # requiresChecks                  Boolean is true for fields of generated types otherwise false
 #  
 # javaTypeCopy(X)                 Prefix-Postfix to make an immutable copy of collections for object
 #                                 fields. Both empty strings in other cases.
 #  
 # javaBuilderTypeCopy(X):         Prefix-Postfix to make a mutable copy of collections for object
 #                                 builders. Both empty strings in other cases.
 #
 # javaGetValue(X):                Prefix-Postfix to get the value object from a generated typedef
 #                                 when referring to it. Both empty strings in other cases.
 #  
 # javaConstructType(X):           Prefix-Postfix to construct an instance of a generated typedef from
 #                                 a value object. Both empty strings in other cases.
 #
 # javaBuilderTypeNew:             Constructor for an empty collection for a builder.
 #  
 # addJsonNode:                    Method name to add an element to the JsonNode for an object
 #  
 # javaCardinality:                Cardinality of a collection, List or Set
 #
 # A subset of these values with the prefix "model" are set for the main model by setModelJavaType.
 #----------------------------------------------------------------------------------------------------->

<#macro printModel>
/* *****************************************************************************************************
 * Model ${javaModel}
 *    name                               ${javaModel.name}
 *    camelName                          ${javaModel.camelName}
 *    camelCapitalizedName               ${javaModel.camelCapitalizedName}
 *    snakeName                          ${javaModel.snakeName}
 *    snakeCapitalizedName               ${javaModel.snakeCapitalizedName}
 *    elementType                        ${javaModel.elementType}
 *
 *    modelJavaClassName                 ${modelJavaClassName!"NULL"}
 *    modelJavaFullyQualifiedClassName   ${modelJavaFullyQualifiedClassName!"NULL"}
 *    modelJavaFieldClassName            ${modelJavaFieldClassName!"NULL"}
 *    modelJavaElementClassName          ${modelJavaElementClassName!"NULL"}
 *    modelJavaCardinality               ${modelJavaCardinality}
 *    modelIsGenerated                   ${modelIsGenerated?c}
 * ****************************************************************************************************/
</#macro>

<#macro printField>
/* ====================================================================================================
 * Field ${javaField}
 *    name                          ${javaField.name}
 *    camelName                     ${javaField.camelName}
 *    camelCapitalizedName          ${javaField.camelCapitalizedName}
 *    snakeName                     ${javaField.snakeName}
 *    snakeCapitalizedName          ${javaField.snakeCapitalizedName}
 *    elementType                   ${javaField.elementType}
 *
 *    javaClassName                 ${javaClassName!"NULL"}
 *    javaFullyQualifiedClassName   ${javaFullyQualifiedClassName!"NULL"}
 *    javaFieldClassName            ${javaFieldClassName!"NULL"}
 *    javaElementClassName          ${javaElementClassName!"NULL"}
 *    isNotNullable                 ${isNotNullable?c}
 *    isArrayType                   ${isArrayType?c}
 *    isGenerated                   ${isGenerated?c}
 *    requiresChecks                ${requiresChecks?c}
 *    javaTypeCopy(X)               ${javaTypeCopyPrefix}X${javaTypeCopyPostfix}
 *    javaBuilderTypeCopy(X)        ${javaBuilderTypeCopyPrefix}X${javaBuilderTypeCopyPostfix}
 *    javaGetValue(X)               ${javaGetValuePrefix}X${javaGetValuePostfix}
 *    javaConstructType(X)          ${javaConstructTypePrefix}X${javaConstructTypePostfix}
 *    javaBuilderTypeNew            ${javaBuilderTypeNew}
 *    addJsonNode                   ${addJsonNode}
 *    javaCardinality               ${javaCardinality}
 * ==================================================================================================*/
</#macro>

<#------------------------------------------------------------------------------------------------------
 # 
 # This macro is called only from the template prologue. It calls setModelJavaType and if debug is
 # enabled it prints information about the model and all its fields in a comment.
 #
 #----------------------------------------------------------------------------------------------------->
<#macro setPrologueJavaType model>
<@setModelJavaType model/>
<#if templateDebug??>
<@printModel/>
</#if>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # 
 # This macro sets a list of variables for the main model element in a template.
 #
 #----------------------------------------------------------------------------------------------------->
<#macro setModelJavaType model>
  <#assign javaModel=model>
  <#assign modelJavaFieldClassName="">
  <#assign modelJavaElementClassName="">
  <#assign modelJavaCardinality="">
  <#-- 
   #
   # First set modelJavaClassName, modelJavaFullyQualifiedClassName, and modelIsGenerated
   #
   #-->
  <#if model.attributes['javaExternalType']??>
    <#assign modelJavaClassName=model.attributes['javaExternalType']>
    <#assign modelJavaFullyQualifiedClassName="${model.attributes['javaExternalPackage']}.${modelJavaClassName}">
    <#assign modelIsGenerated=false>
  <#else>
    <#assign modelJavaClassName=model.camelCapitalizedName>
    <#assign modelJavaFullyQualifiedClassName="${javaFacadePackage}.${modelJavaClassName}">
    <#assign modelIsGenerated=true>
  </#if>
  <#-- 
   #
   # Set javaElementClassName which is the basic Java type which stores simple values
   # and javaImplementationClassName which is the name of a class to be generated.
   #
   #-->
  <#switch model.elementType>
    <#case "Integer">
    <#case "Double">
    <#case "String">
    <#case "Boolean">
      <#assign modelJavaElementClassName=getJavaElementType(model)/>      
      <#break>
      
    <#case "Array">
      <#assign modelJavaElementClassName=getJavaElementType(model.items)/>
      <#break>
    
    <#case "Ref">
      // INVALID SCHEMA ELEMENT OF TYPE Ref for model ${model}
      <#break>
    
    <#case "Object">
    <#case "AllOf">
    <#case "OneOf">
      <#assign modelJavaElementClassName=model.camelCapitalizedName/>
      <#break>
      
    <#default>
      <#-- this is the only place we need to check for an unknown element type -->
      // UNKNOWN ELEMENT TYPE ${model.elementType} for model ${model}
  </#switch>
  <#-- 
   #
   # now set modelJavaFieldClassName and decorator attributes
   #
   #-->
  <#switch model.elementType>
    <#case "Integer">
    <#case "Double">
    <#case "String">
    <#case "Boolean">
      <#assign modelJavaFieldClassName=modelJavaElementClassName>
      <#break>
    
    <#case "Array">
      <#switch model.cardinality>
        <#case "SET">
          <#assign modelJavaFieldClassName="Set<${modelJavaElementClassName}>">
          <#assign modelJavaCardinality="Set">
          <#break>
          
        <#default>
          <#assign modelJavaFieldClassName="List<${modelJavaElementClassName}>">
          <#assign modelJavaCardinality="List">
      </#switch>
      <#break>
    
    <#case "Ref">
    <#case "Object">
    <#case "AllOf">
    <#case "OneOf">
      <#assign modelJavaFieldClassName=modelJavaElementClassName>
      <#break>
  </#switch>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # 
 # This macro sets a list of variables based on the given field modelElement. This is simply a way of 
 # avoiding copies of this logic in multiple templates.
 #
 #----------------------------------------------------------------------------------------------------->
<#macro setJavaType model>
  <#assign javaField=model>
  <#assign javaClassName="">
  <#assign javaFullyQualifiedClassName="">
  <#assign javaGeneratedBuilderClassName="">
  <#assign javaGeneratedBuilderFullyQualifiedClassName="">
  <#assign javaFieldClassName="">
  <#assign javaElementClassName="">
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
  <#assign isArrayType=false>
  <#assign isGenerated=false>
  <#assign requiresChecks=true>
  <#assign javaCardinality="">
  // TTT2 isGenerated = ${isGenerated?c}
  <#-- 
   #
   # first set javaElementClassName which is the basic Java type which stores simple values
   # and javaImplementationClassName which is the name of a class to be generated.
   #
   #-->
   // Trace setJavaType model=${model}
  <#assign javaElementClassName=getJavaElementType(model)/>
  <#-- 
   #
   # now set javaFieldClassName
   #
   #-->
  <@setFieldClassName model/>
  
  <#-- 
   #
   # now set the javaClassName
   #
   #-->
  <@setClassName model javaFieldClassName/>
  <#-- 
   #
   # now set decorator attributes
   #
   #-->
   
  // TTT4 isGenerated = ${isGenerated?c}
   <@decorate model true/>

</#macro>

<#macro setFieldClassName model>
// Trace setFieldClassName model=${model}
<#switch model.elementType>
    <#case "Ref">
      <@setFieldClassName model.reference/>
      <#break>

    <#case "Integer">
    <#case "Double">
    <#case "String">
    <#case "Boolean">
    <#case "Field">
    <#case "Object">
    <#case "AllOf">
    <#case "OneOf">
      <#assign javaFieldClassName=getJavaElementType(model)>
      <#break>
      
    <#case "Array">
      <#switch model.cardinality>
        <#case "SET">
          <#assign javaFieldClassName="Set<${getJavaElementType(model)}>">
          <#break>
          
        <#default>
          <#assign javaFieldClassName="List<${getJavaElementType(model)}>">
      </#switch>
      <#break>
  </#switch>
</#macro>

<#macro decorate model isNotRef>
   // Trace 1 dec model = ${model} model.elementType = ${model.elementType}
  <#switch model.elementType>
    <#case "Field">
     <#------
      <@decorate model.type false/>
      -->
      <#if model.required>
        <#assign isNotNullable=true>
      </#if>
      <#break>
      
    <#case "Array">
      <#assign isArrayType=true>
      <#assign addJsonNode="addCollectionOf${javaElementClassName}">
      <#assign javaTypeCopyPostfix=")">
      <#assign javaBuilderTypeCopyPostfix=")">
      <#switch model.cardinality>
        <#case "SET">
          <#assign javaCardinality="Set">
          <#assign javaTypeCopyPrefix="ImmutableSet.copyOf(">
          <#assign javaBuilderTypeCopyPrefix=".addAll(">
          <#assign javaBuilderTypeNew=" = new HashSet<>()">
          <#break>
          
        <#default>
          <#assign javaCardinality="List">
          <#assign javaTypeCopyPrefix="ImmutableList.copyOf(">
          <#assign javaBuilderTypeCopyPrefix=".addAll(">
          <#assign javaBuilderTypeNew=" = new LinkedList<>()">
      </#switch>
      <#break>
    
    <#case "Ref">
    <#------
    
    <@decorate model.reference false/>
    ------------->
      <#if isGenerated>
        <#assign javaConstructTypePrefix="new ${javaClassName}(">
      <#else>
        <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.build(">
      </#if>
      <#assign javaConstructTypePostfix=")">
      <#assign javaGetValuePostfix=".getValue()">
      <#------
      <#switch model.reference.elementType>
        <#case "Array">
          <#assign isArrayType=true>
          <#assign javaGetValuePostfix=".getElements()">
          <#assign addJsonNode="addCollectionOf${javaElementClassName}">
          <#switch model.reference.cardinality>
            <#case "SET">
              <#assign javaCardinality="Set">
              <#break>
              
            <#default>
              <#assign javaCardinality="List">
          </#switch>
          <#break>
          
        <#default>
          <#assign javaGetValuePostfix=".getValue()">
      </#switch>
       ------------->
      <#break>
      
    <#case "Object">
    <#case "AllOf">
    <#case "OneOf">
      // TT1 isGenerated = ${isGenerated?c}
      <#if isGenerated>
        <#assign javaConstructTypePrefix="new ${javaClassName}(">
      <#else>
        <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.build(">
      </#if>
      <#assign javaConstructTypePostfix=")">
      <#assign javaGetValuePostfix=".getValue()">
      <#break>
  </#switch>

</#macro>

<#macro setClassName model fieldClassName>

  // TTT3a isGenerated = ${isGenerated?c}
  <#switch model.elementType>
    <#case "Ref">
      <@setClassName model.reference model.reference.camelCapitalizedName/>
      <#assign javaFullyQualifiedClassName="${javaFacadePackage}.${javaClassName}">
      <#assign requiresChecks=false>
      
  // TTT3c isGenerated = ${isGenerated?c}
      <#break>
      
    <#case "Integer">
    <#case "Double">
    <#case "String">
    <#case "Boolean">    
    <#case "Object">
    <#case "AllOf">
    <#case "OneOf">
      <#if model.attributes['javaExternalType']??>
        <#assign javaClassName=model.attributes['javaExternalType']>
        <#assign javaFullyQualifiedClassName="${model.attributes['javaExternalPackage']}.${javaClassName}">
        <#assign requiresChecks=false>
        <#assign javaGeneratedBuilderClassName=model.camelCapitalizedName>
        <#assign javaGeneratedBuilderFullyQualifiedClassName="${javaFacadePackage}.${javaGeneratedBuilderClassName}Builder">
      <#else>
        <#assign javaClassName=model.camelCapitalizedName>
        <#assign javaFullyQualifiedClassName="${javaFacadePackage}.${javaClassName}">
      <#assign isGenerated=true>
      
  // TTT3b isGenerated = ${isGenerated?c}
      </#if>
      <#break>
    
    <#case "Field">
    <#case "Array">
      <#assign javaClassName=fieldClassName>
      <#break>

  </#switch>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # return javaElementClassName based on the underlying Java type
 #----------------------------------------------------------------------------------------------------->
<#function getJavaElementType model>
  <#switch model.elementType>
    <#case "Integer">
      <#switch model.format>
        <#case "int32">
          <#return "Integer">
          
         <#default>
          <#return "Long">
      </#switch>
      <#break>
      
    <#case "Double">
      <#switch model.format>
        <#case "float">
          <#return "Float">
        
        <#default>
          <#return "Double">
      </#switch>
      <#break>
    
    <#case "String">
      <#switch model.format>
        <#case "byte">
          <#return "ByteString">
        
        <#default>
          <#return "String">
      </#switch>
      <#break>
    
    <#case "Boolean">
      <#return "Boolean">
    
    <#case "Field">
      <#return getJavaElementType(model.type)/>
      <#break>
    
    <#case "Array">
      <#return getJavaElementType(model.items)/>
      <#break>
    
    <#case "Ref">
      <#return getJavaElementType(model.reference)/>
      <#break>
      
    <#default>
      <#-- this is the only place we need to check for an unknown element type -->
      <#return "UNKNOWN ELEMENT TYPE ${model.elementType} for model ${model}"/>
  </#switch>
</#function>



<#macro importFieldTypes model includeImpls>
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
import ${javaFacadePackage}.${model.camelCapitalizedName}.${field.camelCapitalizedName};
this just seems wrong, is it even ever called?
//import ${field.model.modelMap["javaFacadePackage"]}.${model.camelCapitalizedName}.${field.camelCapitalizedName};
      <#break>
  
      <#default>
  <@setJavaType field/>
import ${javaFullyQualifiedClassName};
<#if javaGeneratedBuilderFullyQualifiedClassName?has_content>
import ${javaGeneratedBuilderFullyQualifiedClassName};
</#if>
    </#switch>  
  </#list>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # 
 # Limit checking.
 #
 # I think we can just look for all checks in all cases rather than doing array limits and value limits
 # separately.
 #----------------------------------------------------------------------------------------------------->


<#-----
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
------------>

<#macro checkLimitsClassThrows model><#list model.fields as field><#if isCheckLimits(field)> throws BadFormatException<#return></#if></#list></#macro>

<#macro checkLimitsThrows model><#if isCheckLimits(model)> throws BadFormatException</#if></#macro>

<#function isCheckLimits model>
  <#switch model.elementType>
    <#case "Field">
      <#if model.type.minimum?? ||  model.type.maximum?? || model.required>
        <#return true>
      </#if>
      <#break>
      
    <#case "Ref">
      <#return isCheckLimits(model.reference)/>
      <#break>
      
    <#case "Array">
      <#if model.minimum?? ||  model.maximum??>
        <#return true>
      </#if>
      
    <#default>
      <#if model.minItems?? ||  model.maxItems??>
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





















<#-- ----------------------------------------- OLD STUFF ----------------------------------------- -->



<#--- need to putthis somewhere....
  <#assign javaImplementationClassName=javaClassName>
  <#if model.attributes['javaExternalType']??>
    <#assign javaClassName=model.attributes['javaExternalType']>
    <#assign javaFullyQualifiedClassName="${model.attributes['javaExternalPackage']}.${javaClassName}">
  </#if>
--->  




<#function effectiveModelOf model>
  <#switch model.elementType>
    <#case "Ref">
      <#return model.reference>
    
    <#default>
      <#return model>
  </#switch>
</#function>

<#function javaTypeOf model>
  <#switch model.elementType>
    <#case "Integer">
      <#switch model.format>
        <#case "int32">
          <#return "Integer">
          <#break>
          
         <#default>
          <#return "Long">
      </#switch>

    <#case "Double">
      <#switch model.format>
        <#case "float">
          <#return "Float">
          <#break>
        
        <#default>
          <#return "Double">
      </#switch>
      
    <#case "String">
      <#switch model.format>
        <#case "byte">
          <#return "ByteString">
          <#break>
        
        <#default>
          <#return "String">
      </#switch>
      
    <#case "Boolean">
      <#return "Boolean">
      
    <#case "Field">
      <#return javaTypeOf(model.type)>

    <#case "Array">
      <@setJavaType2 model.items/>
      <#assign addJsonNode="addCollectionOf${javaType}">
      <#assign javaTypeCopyPostfix=")">
      <#assign javaBuilderTypeCopyPostfix=")">
      <#switch model.cardinality>
        <#case "SET">
          <#return "Set<${javaTypeOf(model.items)}>">
          
        <#default>
          <#return "List<${javaTypeOf(model.items)}>">
      </#switch>
      <#break>
    
    <#case "Ref">
      <#if model.reference.attributes['javaExternalType']??>
        <#return model.reference.attributes['javaExternalType']>
      </#if>
      <#return model.reference.camelCapitalizedName>
      
    <#case "Object">
    <#case "AllOf">
    <#case "OneOf">
      <#return model.camelCapitalizedName>
      <#break>
      
    <#default>
      <#return "UNKNOWN ELEMENT TYPE ${model.elementType} for model ${model}">
  </#switch>
</#function>

<#-- 
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

<#macro setJavaType4 model>
  <@setJavaType2 model/>
  <#assign javaType=model.camelCapitalizedName>
  <#assign javaConstructTypePrefix="new ${javaType}(">
  <#assign javaConstructTypePostfix=")">
  <@setJavaType3 model/>
  <#assign javaGetValuePostfix=".getValue()">
</#macro>
-->




<#--
<#macro OBSOLETEsetJavaType model>
  <#assign actualModel=model>
  <#assign effectiveModel=model>
  
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
      <#assign effectiveModel=model.type>
      <@setJavaType4 model.type/>
      <#break>
    
    <#case "Array">
      <@setJavaType2 model.items/>
      <#assign addJsonNode="addCollectionOf${javaType}">
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
      <@setJavaType4 model/>
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
-->


