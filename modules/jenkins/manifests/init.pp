class jenkins{
include jenkins::repo
include jenkins::install
include jenkins::proxy
include jenkins::jobbuilder
include jenkins::config
include jenkins::gitvcs
}
