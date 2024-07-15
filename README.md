# UVM Test Template

While trying to improve my UVM skills, I decided it was improtant to be able to set up a UVM environment from scratch. This would include the dependency handling done by the Makefile. The template is usable from the get-go and can be adapted to different projects. The DUT can be placed in the _rtl_ folder and the _filelist.txt_ needs to be updated to include the source. Additional components like agents can be added to the _tb/components_ folder and the corresponding filelist.txt must be updated. The agent is referenced in the _env.sv_ file, so adding new agents can be done there.

The test and rtl were adapted from an example on ChipVerify.com, but the encompassing Makefile structure and environment were self-developed. Modifications since then will have made the RTL completely customized and separate from the aforementioned example.


## Building

To run a simulation:
```
make clean
make compile
make run TEST=test_1011 VERBOSE=UVM_HIGH
```

