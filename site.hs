--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll

import Data.Monoid ((<>)) -- I suspect this is the same as `mappend`

-- ~ import Hakyll ((.&&.), applyTemplateList, buildTags, compile, complement, compressCssCompiler, constField,
               -- ~ copyFileCompiler, dateField, defaultContext, defaultHakyllReaderOptions,
               -- ~ defaultHakyllWriterOptions, fromCapture, getRoute, hakyll, idRoute, itemIdentifier,
               -- ~ loadAll, loadAndApplyTemplate, loadBody, makeItem, match, modificationTimeField,
               -- ~ pandocCompilerWithTransform, preprocess, relativizeUrls, route, setExtension,
               -- ~ tagsField, tagsRules, templateCompiler, Compiler, Context, Item, Pattern, Tags)


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do

    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.org", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

-- duplicate post add for .org files
    match "posts/*.org" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
-- Adding the date field to the post context
postCtx :: Context String
postCtx =
    -- modificationTimeField "modified" "%B %e %Y" `mappend` -- based on filesystem mod times
    dateField "date" "%B %e, %Y" `mappend`
    -- ~ constField "modified" "July 9, 2016" `mappend`
    defaultContext --`mappend` -- <>
    -- looks like metatdataField is already part of it?
    --   yeah -> https://jaspervdj.be/hakyll/reference/Hakyll-Web-Template-Context.html#v:defaultContext
    -- metadataField -- Think it might just add in all metadata fields


-- ~ postCtx :: Tags -> Context String
-- ~ postCtx tags =
    -- ~ tagsField "tags" tags <>
    -- ~ defaultContext <>
    -- ~ dateField "created" "%d %b %Y" <>
    -- ~ modificationTimeField "modified" "%d %b %Y" <>
    -- ~ constField "author" "gwern" <>
    -- ~ constField "status" "N/A" <>
    -- ~ constField "belief" "N/A" <>
    -- ~ constField "description" "N/A"
