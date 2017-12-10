<#include "../S2-japigen-proforma-java-Prologue.ftl">

import com.symphony.s2.japigen.runtime.IModelFactory;

import ${javaGenPackage}.I${model.camelCapitalizedName}ModelFactory;

public interface I${model.camelCapitalizedName}Factory extends I${model.camelCapitalizedName}ModelFactory
{
  
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">