# Agrupar archivos por tipo
file(GLOB_RECURSE HEADER_FILES
    "*.hpp"
    "*.h"
)

file(GLOB_RECURSE SOURCE_FILES
    "*.cpp"
    "*.c"
)

file(GLOB_RECURSE RESOURCES_FILES
    "*.rc"
    "*.ico"
)

source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} PREFIX "Header Files" FILES ${HEADER_FILES})
source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} PREFIX "Source Files" FILES ${SOURCE_FILES})
source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} PREFIX "Resources Files" FILES ${RESOURCES_FILES})

# Crear el ejecutable
add_executable(${PROJECT_NAME} ${HEADER_FILES} ${SOURCE_FILES} ${RESOURCES_FILES})

# Enlace de bibliotecas
target_link_libraries(${PROJECT_NAME} SDL2::SDL2 ZLIB::ZLIB ${HASH_LIBRARY_TGT_NAME})

if(PSP)
    option(WOLFENSTEIN_PSP_LOG "Write verbose PSP diagnostics to Memory Stick" OFF)
    find_package(SDL2_mixer REQUIRED)
    target_compile_definitions(${PROJECT_NAME} PRIVATE
        WOLFENSTEIN_PSP=1
        WOLFENSTEIN_BUILD_ID="${WOLFENSTEIN_BUILD_ID}"
        WOLFENSTEIN_PSP_LOG=$<BOOL:${WOLFENSTEIN_PSP_LOG}>)
    target_compile_options(${PROJECT_NAME} PRIVATE -include cstdint -Wno-narrowing -fpermissive)
    target_link_libraries(${PROJECT_NAME} SDL2::mixer
        GL openal modplug vorbisfile vorbis ogg pspvram pspaudiolib pspaudio pspvfpu
        pspdisplay pspgu pspge psphprm pspctrl psppower stdc++ m)
    create_pbp_file(
        TARGET ${PROJECT_NAME}
        TITLE "Wolfenstein RPG"
        ICON_PATH "${PROJECT_SOURCE_DIR}/assets/psp/ICON0-user.png"
        BACKGROUND_PATH "${PROJECT_SOURCE_DIR}/assets/psp/PIC1-user.PNG"
        PREVIEW_PATH NULL)
elseif (CMAKE_SYSTEM_NAME STREQUAL "Windows")
    target_link_libraries(${PROJECT_NAME} OpenAL::OpenAL ${OPENGL_gl_LIBRARY})
elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
    target_link_libraries(${PROJECT_NAME} OpenGL::GL ${OPENAL_LIBRARY})
    # Verifica si realmente necesitas una compilación estática
    target_link_options(${PROJECT_NAME} PRIVATE -static-libgcc -static-libstdc++)
endif()
