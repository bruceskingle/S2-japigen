<#include "../S2-japigen-template-java-Prologue.ftl">

<@importFieldTypes model true/>
import ${javaFacadePackage}.${model.camelCapitalizedName};
import ${javaFacadePackage}.${model.camelCapitalizedName}.Builder;

<#include "Object.ftl">
public interface I${model.camelCapitalizedName}ModelObject
{
<#list model.children as field>
  <@setJavaType field/>
  
  ${javaType} get${field.camelCapitalizedName}();
</#list>
}
<#include "../S2-japigen-template-java-Epilogue.ftl">