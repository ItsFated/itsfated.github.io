
if [[ $1 == "root" ]]; then
    sed -i 's|](../img/|](img/|g' $(find source/_posts/ -type f)
else
    sed -i 's|](img/|](../img/|g' $(find source/_posts/ -type f)
fi
