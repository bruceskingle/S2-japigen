<#include "../S2-japigen-proforma-java-Prologue.ftl">

import com.symphony.s2.japigen.runtime.IModelSchemas;

import ${javaGenPackage}.I${model.camelCapitalizedName}ModelSchemas;

public interface I${model.camelCapitalizedName}Schemas extends I${model.camelCapitalizedName}ModelSchemas
{
  
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">