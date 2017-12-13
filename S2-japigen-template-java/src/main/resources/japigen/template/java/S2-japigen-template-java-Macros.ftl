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
 # isExternal                      Boolean is true for external types otherwise false
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
 *    canFailValidation                  ${javaModel.canFailValidation?c}
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
 *    canFailValidation             ${javaField.canFailValidation?c}
 *
 *    javaClassName                 ${javaClassName!"NULL"}
 *    javaFullyQualifiedClassName   ${javaFullyQualifiedClassName!"NULL"}
 *    javaFieldClassName            ${javaFieldClassName!"NULL"}
 *    javaElementClassName          ${javaElementClassName!"NULL"}
 *    isNotNullable                 ${isNotNullable?c}
 *    isArrayType                   ${isArrayType?c}
 *    isGenerated                   ${isGenerated?c}
 *    isExternal                    ${isExternal?c}
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
  <#assign isExternal=false>
  <#assign requiresChecks=true>
  <#assign javaCardinality="">
  <#-- 
   #
   # first set javaElementClassName which is the basic Java type which stores simple values
   # and javaImplementationClassName which is the name of a class to be generated.
   #
   #-->
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
   <@decorate model true/>
</#macro>

<#macro setFieldClassName model>
<#switch model.elementType>
    <#case "Ref">
      <@setFieldClassName model.reference/>
      <#break>

    <#case "Field">
      <#if model.type.elementType=="Array">
        <@setFieldClassName model.type/>
      <#else>
        <#assign javaFieldClassName=getJavaElementType(model)>
      </#if>
      <#break>
    
    <#case "Integer">
    <#case "Double">
    <#case "String">
    <#case "Boolean">
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
  <#switch model.elementType>
    <#case "Field">
      <#if model.required>
        <#assign isNotNullable=true>
      </#if>
      <@decorateIfArray model.type/>
      <#break>
      
    <#case "Array">
      <@decorateIfArray model/>
      <#break>
      
    <#case "Ref">
      <#if javaGeneratedBuilderClassName?has_content>
        <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.build(">
      <#else>
        <#assign javaConstructTypePrefix="new ${javaClassName}(">
      </#if>
      <#assign javaConstructTypePostfix=")">
      <#switch model.reference.elementType>
        <#case "Array">
          <#assign javaGetValuePostfix=".getElements()">
          <#break>
        
        <#case "Object">
        <#case "AllOf">
        <#case "OneOf">
          <#assign javaGetValuePostfix=".getJsonObject()">
          <#assign addJsonNode="add">
          <#break>
        
        <#default>
          <#if isExternal>
            <#assign javaGetValuePrefix="${javaGeneratedBuilderClassName}.to${javaElementClassName}(">
            <#assign javaGetValuePostfix=")">
            <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.build(">
            <#assign javaConstructTypePostfix=")">
          <#else>
            <#assign javaGetValuePostfix=".getValue()">
          </#if>
      </#switch>
      <@decorateIfArray model.reference/>
      <#break>
      
    <#case "Object">
    <#case "AllOf">
    <#case "OneOf">
      <#if javaGeneratedBuilderClassName?has_content>
        <#assign javaConstructTypePrefix="${javaGeneratedBuilderClassName}.build(">
      <#else>
        <#assign javaConstructTypePrefix="new ${javaClassName}(">
      </#if>
      <#assign javaConstructTypePostfix=")">
      <#assign javaGetValuePostfix=".getJsonObject()">
      <#assign addJsonNode="add">
      <#break>
  </#switch>
</#macro>

<#macro decorateIfArray model>
  <#if model.elementType=="Array">
    <#assign isArrayType=true>
    <#assign addJsonNode="addCollectionOf${javaElementClassName}">
    <#if !isGenerated>
      <#assign javaTypeCopyPostfix=")">
      <#assign javaBuilderTypeCopyPostfix=")">
      <#switch model.cardinality>
        <#case "SET">
          <#assign javaTypeCopyPrefix="ImmutableSet.copyOf(">
          <#assign javaBuilderTypeCopyPrefix=".addAll(">
          <#assign javaBuilderTypeNew=" = new HashSet<>()">
          <#break>
          
        <#default>
          <#assign javaTypeCopyPrefix="ImmutableList.copyOf(">
          <#assign javaBuilderTypeCopyPrefix=".addAll(">
          <#assign javaBuilderTypeNew=" = new LinkedList<>()">
      </#switch>
    </#if>
    <#switch model.cardinality>
      <#case "SET">
        <#assign javaCardinality="Set">
        <#break>
        
      <#default>
        <#assign javaCardinality="List">
    </#switch>
  </#if>
</#macro>

<#macro setClassName model fieldClassName>
  <#switch model.elementType>
    <#case "Ref">
      <@setClassName model.reference model.reference.camelCapitalizedName/>
      <#assign javaFullyQualifiedClassName="${javaFacadePackage}.${javaClassName}">
      <#assign requiresChecks=false>
      <#break>
    <#case "Array">
    <#case "Integer">
    <#case "Double">
    <#case "String">
    <#case "Boolean">    
    <#case "Object">
    <#case "AllOf">
    <#case "OneOf">
      <#assign isGenerated=true>
      <#if model.attributes['javaExternalType']??>
        <#assign isExternal=true>
        <#assign javaClassName=model.attributes['javaExternalType']>
        <#assign javaFullyQualifiedClassName="${model.attributes['javaExternalPackage']}.${javaClassName}">
        <#assign requiresChecks=false>
        <#assign javaGeneratedBuilderClassName="${model.camelCapitalizedName}Builder">
        <#assign javaGeneratedBuilderFullyQualifiedClassName="${javaFacadePackage}.${javaGeneratedBuilderClassName}">
      <#else>
        <#assign javaClassName=model.camelCapitalizedName>
        <#assign javaFullyQualifiedClassName="${javaFacadePackage}.${javaClassName}">
      </#if>
      <#break>
    
    <#case "Field">
    <#case "OneOf">
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
    
    <#case "OneOf">
    <#case "AllOf">
      <#return "IModelObject">
      <#break>
      
    <#default>
      <#-- this is the only place we need to check for an unknown element type -->
      <#return "UNKNOWN ELEMENT TYPE ${model.elementType} for model ${model}"/>
  </#switch>
</#function>


<#------------------------------------------------------------------------------------------------------
 # Generate imports for the nested types included in the given model element
 #
 # @param model     A model element
 #----------------------------------------------------------------------------------------------------->
<#macro importNestedTypes model>
  <#if model.elementType!="AllOf">
    <#list model.children as field>
      <#switch field.elementType>
        <#case "Object">
        <#case "AllOf">
        <#case "OneOf">
import ${javaFacadePackage}.${field.camelCapitalizedName};
          <@importNestedTypes field/>
          <#break>
      </#switch>
    </#list>
  </#if> 
</#macro>

<#------------------------------------------------------------------------------------------------------
 # Generate Factory declarations
 #
 # This is probably only needed from _ModelFactory.java.ftl
 #
 # @param model     A model element.
 # @param object    A field within the model element.
 #----------------------------------------------------------------------------------------------------->
<#macro declareFactories model object>
  <#if object.elementType!="AllOf">
    <#list object.children as child>
      <#switch child.elementType>
        <#case "Object">
        <#case "AllOf">
          <@declareFactories model child/>
          <#-- FALL THROUGH -->
        <#case "OneOf">
  private final ${(child.camelCapitalizedName + ".Factory")?right_pad(35)}  ${(child.camelName + "Factory_")?right_pad(35)} = new ${child.camelCapitalizedName}.Factory((${model.camelCapitalizedName}Factory)this);
          <#break>
      </#switch>
    </#list>
  </#if>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # Generate Factory registrations
 #
 # This is probably only needed from _ModelFactory.java.ftl
 #
 # @param model     A model element.
 # @param object    A field within the model element.
 #----------------------------------------------------------------------------------------------------->
<#macro registerFactories model object>
  <#if object.elementType!="AllOf">
    <#list object.children as child>
      <#switch child.elementType>
        <#case "Object">
        <#case "AllOf"> 
          <#-- FALL THROUGH -->      
        <#case "OneOf">
    registry.register(${(child.camelCapitalizedName + ".TYPE_ID,")?right_pad(45)} ${child.camelName}Factory_);
          <@registerFactories model child/>
          <#break>
      </#switch>
    </#list>
  </#if>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # Generate Factory getters
 #
 # This is probably only needed from _ModelFactory.java.ftl
 #
 # @param model     A model element.
 # @param object    A field within the model element.
 #----------------------------------------------------------------------------------------------------->
<#macro getFactories model object>
  <#if object.elementType!="AllOf">
    <#list object.children as child>
      <#switch child.elementType>
        <#case "Object">
        <#case "AllOf">
          <@getFactories model child/>
          <#-- FALL THROUGH -->
        <#case "OneOf">

    public ${child.camelCapitalizedName}.Factory get${child.camelCapitalizedName}Factory()
    {
      return ${child.camelName}Factory_;
    }
          <#break>
      </#switch>
    </#list>
  </#if>
</#macro>


<#macro importFieldTypes model includeImpls>
  <#if model.hasList || model.hasSet || model.elementType=="OneOf">
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
    <@setJavaType field/>
    <#if javaFullyQualifiedClassName?has_content>
import ${javaFullyQualifiedClassName};
    </#if>
    <#if javaGeneratedBuilderFullyQualifiedClassName?has_content>
import ${javaGeneratedBuilderFullyQualifiedClassName};
    </#if>
    <@importNestedTypes field/>
  </#list>
  <@importNestedTypes model/>
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



<#------------------------------------------------------------------------------------------------------
 # Generate min/max checks for the given type if necessary
 #
 # This is a macro sub-routine, from templates you probably should be calling checkLimits.
 #
 # @param indent    An indent string which is output at the start of each line generated
 # @param model     A model element representing the field to generate for
 # @param name      The name of the value being checked which is output in the message of thrown exceptions
 #----------------------------------------------------------------------------------------------------->
<#macro checkLimits2 indent model name>
  <#if model.minimum??>
${indent}if(${name} != null && ${name} < ${model.minimumAsString})
${indent}  throw new BadFormatException("Value " + ${name} + " of ${name} is less than the minimum allowed of ${model.minimum}");
  </#if>
  <#if model.maximum??>

${indent}if(${name} != null && ${name} > ${model.maximumAsString})
${indent}  throw new BadFormatException("Value " + ${name} + " of ${name} is more than the maximum allowed of ${model.maximum}");
  </#if>
</#macro>

<#------------------------------------------------------------------------------------------------------
 # Generate limit checks for the given type if necessary
 #
 # @param indent    An indent string which is output at the start of each line generated
 # @param model     A model element representing the field to generate for
 # @param name      The name of the value being checked which is output in the message of thrown exceptions
 #----------------------------------------------------------------------------------------------------->
<#macro checkLimits indent model name>
  <#switch model.elementType>
    <#case "Integer">
    <#case "Double">
    <#case "String">
      <@checkLimits2 indent model name/>
      <#break>
      
    <#case "Field">
      <@checkLimits2 indent model.type name/>
      <#if model.required>
${indent}if(${name} == null)
${indent}  throw new BadFormatException("${name} is required.");

      </#if>
      <#break>
  </#switch>
</#macro>


<#------------------------------------------------------------------------------------------------------
 # Generate limit checks for the given Array type if necessary
 #
 # @param indent    TO BE ADDED: An indent string which is output at the start of each line generated
 # @param model     A model element representing the field to generate for
 # @param var       The name of a variable to which the extracted value will be assigned 
 # @param name      The name of an array value being checked
 #----------------------------------------------------------------------------------------------------->
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

<#------------------------------------------------------------------------------------------------------
 # 
 # Create a field from a Json DOM node.
 #
 # NB this macro calls <@setJavaType field/>
 # @param indent    An indent string which is output at the start of each line generated
 # @param field     A model element representing the field to generate for
 # @param var       The name of a variable to which the extracted value will be assigned 
 #----------------------------------------------------------------------------------------------------->
<#macro generateCreateFieldFromJsonDomNode indent field var>
// generateCreateFieldFromJsonDomNode field.elementType = ${field.elementType} field = ${field}
  <@setJavaType field/>
  <#if field.elementType=="Ref">
    <#assign elementType=field.reference.elementType>
  <#else>
    <#assign elementType=field.elementType>
  </#if>
  
  <#if isGenerated>
    <#switch elementType>
      <#case "Object">
      <#case "AllOf">
      <#case "OneOf">
${indent}if(node instanceof ImmutableJsonObject)
${indent}{
${indent}  ${var} = _factory.getFactory().get${javaClassName}Factory().newInstance((ImmutableJsonObject)node);
${indent}}
${indent}else
${indent}{
${indent}  throw new BadFormatException("${field.camelName} must be an Object node not " + node.getClass().getName());
${indent}}
        <#break>
      
      <#default>
${indent}${var} = ${javaConstructTypePrefix}node${javaConstructTypePostfix};
        <#break>
    </#switch>
  <#else>
    <#if isArrayType>
${indent}if(node instanceof JsonArray)
${indent}{
${indent}  ${var} = ((JsonArray<?>)node).asImmutable${javaCardinality}Of(${javaElementClassName}.class);
${indent}  <@checkItemLimits field field.camelName var/>
${indent}}
${indent}else
${indent}{
${indent}  throw new BadFormatException("${field.camelName} must be an array not " + node.getClass().getName());
${indent}}
    <#else>  
${indent}if(node instanceof I${javaElementClassName}Provider)
${indent}{
${indent}  ${javaFieldClassName} ${field.camelName} = ${javaConstructTypePrefix}((I${javaElementClassName}Provider)node).as${javaElementClassName}()${javaConstructTypePostfix};
      <#if requiresChecks>
        <@checkLimits "${indent}  " field field.camelName/>
      </#if>
${indent}  ${var} = ${javaTypeCopyPrefix}${field.camelName}${javaTypeCopyPostfix};
${indent}}
${indent}else
${indent}{
${indent}  throw new BadFormatException("${field.camelName} must be an instance of ${javaFieldClassName} not " + node.getClass().getName());
${indent}}
    </#if>
  </#if>
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


