list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")
cmake_minimum_required(VERSION 3.2)

project("pencilcc")
set(PENCILCC_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
set(PENCILCC_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}")

set(CMAKE_C_STANDARD 99)

add_subdirectory(prl)
add_subdirectory(ppcg)



function (gen_pencilcc)
  configure_file(
    ${PENCILCC_SOURCE_DIR}/pencilcc.py.in
    ${PENCILCC_BINARY_DIR}/pencilcc.py
    @ONLY)
endfunction ()

gen_pencilcc()
add_custom_target(pencilcc
  DEPENDS ${PENCILCC_BINARY_DIR}/pencilcc.py
)


#add_custom_command(OUTPUT "${PENCILCC_BINARY_DIR}/correlation.ppcg_prl.c"
#  DEPENDS "${POLYBENCH_DIR}/datamining/correlation/correlation.c"
#  COMMAND ppcg --target=prl "-I${POLYBENCH_DIR}/utilities" "${POLYBENCH_DIR}/datamining/correlation/correlation.c" -o "${PENCILCC_BINARY_DIR}/correlation.ppcg_prl.c"
#)
#add_executable(correlation_prl "${POLYBENCH_DIR}/utilities/polybench.c" "${PENCILCC_BINARY_DIR}/correlation.ppcg_prl.c")
#target_include_directories(correlation_prl PRIVATE "${POLYBENCH_DIR}/datamining/correlation" "${POLYBENCH_DIR}/utilities")
#target_link_libraries(correlation_prl prl_opencl)
#set_target_properties(correlation_prl PROPERTIES C_STANDARD 99)




#add_custom_command(OUTPUT "${PENCILCC_BINARY_DIR}/timing.ppcg_prl.c"
#  DEPENDS "${PENCILCC_SOURCE_DIR}/tests/timing.c"
#  COMMAND ppcg --target=prl "${PENCILCC_SOURCE_DIR}/tests/timing.c" "-I${PENCILCC_SOURCE_DIR}/prl/include" -o "${PENCILCC_BINARY_DIR}/timing.ppcg_prl.c"
#)
#add_executable(timing "${PENCILCC_BINARY_DIR}/timing.ppcg_prl.c")
#target_link_libraries(timing prl_opencl)


add_custom_command(OUTPUT "${PENCILCC_BINARY_DIR}/prl_alloc.ppcg_prl.c"
  DEPENDS "${PENCILCC_SOURCE_DIR}/tests/prl_alloc.c"
  COMMAND ppcg --target=prl "${PENCILCC_SOURCE_DIR}/tests/prl_alloc.c" "-I${PENCILCC_SOURCE_DIR}/prl/include" -o "${PENCILCC_BINARY_DIR}/prl_alloc.ppcg_prl.c"
)
add_executable(prl_alloc "${PENCILCC_BINARY_DIR}/prl_alloc.ppcg_prl.c")
target_link_libraries(prl_alloc prl_opencl)


add_custom_command(OUTPUT "${PENCILCC_BINARY_DIR}/prl_manage_host.ppcg_prl.c"
  DEPENDS "${PENCILCC_SOURCE_DIR}/tests/prl_manage_host.c"
  COMMAND ppcg --target=prl "${PENCILCC_SOURCE_DIR}/tests/prl_manage_host.c" "-I${PENCILCC_SOURCE_DIR}/prl/include" -o "${PENCILCC_BINARY_DIR}/prl_manage_host.ppcg_prl.c"
)
add_executable(prl_manage_host "${PENCILCC_BINARY_DIR}/prl_manage_host.ppcg_prl.c")
target_link_libraries(prl_manage_host prl_opencl)

add_custom_command(OUTPUT "${PENCILCC_BINARY_DIR}/prl_manage.ppcg_prl.c"
  DEPENDS "${PENCILCC_SOURCE_DIR}/tests/prl_manage.c"
  COMMAND ppcg --target=prl "${PENCILCC_SOURCE_DIR}/tests/prl_manage.c" "-I${PENCILCC_SOURCE_DIR}/prl/include" -o "${PENCILCC_BINARY_DIR}/prl_manage.ppcg_prl.c"
)
add_executable(prl_manage "${PENCILCC_BINARY_DIR}/prl_manage.ppcg_prl.c")
target_link_libraries(prl_manage prl_opencl)




enable_testing()
